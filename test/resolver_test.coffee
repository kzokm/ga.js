'use strict'
{expect} = require 'chai'

describe 'Resolver', ->
  Resolver = require '../lib/resolver'
  it 'should be a function', ->
    expect Resolver
      .to.be.a 'function'

  Popuration = require '../lib/popuration'

  it 'should throw error if reproduct handler is not function', ->
    expect Resolver::constructor
      .to.throw TypeError

  describe '#resolve', ->
    popuration = undefined
    beforeEach ->
      popuration = new Popuration

    it 'should return resolver it self', ->
      resolver = new Resolver ->
      expect resolver.resolve popuration, terminate: 0
        .to.equal resolver

    it 'should invoke reproduction function and call event handler each processing', (done)->
      config = terminate: terminate = 5
      numReprocucted = numReprocuctHandlerCalled = numTerminateHandlerCalled = 0

      resolver = new Resolver ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [popuration, config]
        expect popuration.generationNumber
          .to.equal numReprocucted++
        popuration
      .on 'reproduct', ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [popuration, config]
        expect popuration.generationNumber
          .to.equal numReprocucted
        numReprocuctHandlerCalled++
      .on 'terminate', ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [popuration, config]
        expect popuration.generationNumber
          .to.equal terminate
          .that.equals numReprocuctHandlerCalled
        numTerminateHandlerCalled++
      .resolve popuration, config, ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [popuration, config]
        expect popuration.generationNumber
          .to.equal terminate
          .that.equals numReprocucted
          .that.equals numReprocuctHandlerCalled
        expect numTerminateHandlerCalled
          .to.equal 1
        done()

    it 'should repeat invoking reprodution function each interval time.', (done)->
      count = 1
      prev = undefined
      new Resolver ->
          current = new Date().getTime()
          if prev
            expect current - prev
              .to.be.above 100
              .to.be.below 120
          prev = current
          popuration
        , intervalMillis: 100, terminate: 10
      .resolve popuration, ->
        done()

    it 'should terminate initiazlied condition', (done)->
      new Resolver (->), terminate: 3
        .resolve popuration, ->
          expect popuration.generationNumber
            .to.equal 3
          done()

    it 'can override termination condition', (done)->
      new Resolver (->), terminate: 3
        .resolve popuration, terminate: 5, ->
          expect popuration.generationNumber
            .to.equal 5
          done()

    it 'should terminate when matching any conditions', (done)->
      new Resolver (->), terminate: [
        -> popuration.generationNumber == 5
        -> popuration.generationNumber == 3
        ]
      .resolve popuration, ->
        expect popuration.generationNumber
          .to.equal 3
        done()
