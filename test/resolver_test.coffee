'use strict'
{expect} = require 'chai'

describe 'Resolver', ->
  Resolver = require '../lib/resolver'
  it 'should be a function', ->
    expect Resolver
      .to.be.a 'function'

  Population = require '../lib/population'

  describe '#resolve', ->
    population = undefined
    beforeEach ->
      population = new Population

    it 'should return resolver it self', ->
      resolver = new Resolver
      expect resolver.resolve population,
        reproduct: ->
        terminate: 0
      .to.equal resolver

    it 'should throw error if reproduct handler is not function', ->
      resolver = new Resolver
      expect -> resolver.resolve()
        .to.throw TypeError

    it 'should invoke reproduction function and call event handler each processing', (done)->
      config = terminate: terminate = 5
      numReprocucted = numReprocuctHandlerCalled = numTerminateHandlerCalled = 0

      resolver = new Resolver ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [population, config]
        expect population.generationNumber
          .to.equal numReprocucted++
        population
      .on 'reproduct', ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [population, config]
        expect population.generationNumber
          .to.equal numReprocucted
        numReprocuctHandlerCalled++
      .on 'terminate', ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [population, config]
        expect population.generationNumber
          .to.equal terminate
          .that.equals numReprocuctHandlerCalled
        numTerminateHandlerCalled++
      .resolve population, config, ->
        expect @
          .to.equal resolver
        expect Array::slice.apply arguments
          .to.deep.equal [population.best, population, config]
        expect population.generationNumber
          .to.equal terminate
          .that.equals numReprocucted
          .that.equals numReprocuctHandlerCalled
        expect numTerminateHandlerCalled
          .to.equal 1
        done()

    it 'should repeat invoking reprodution function each interval time.', (done)->
      prev = undefined
      new Resolver
        intervalMillis: 100
        reproduct: ->
          current = new Date().getTime()
          if prev
            expect current - prev
              .to.be.above 100
              .to.be.below 120
          prev = current
          population
        terminate: 10
      .resolve population, ->
        done()

    it 'should terminate initiazlied condition', (done)->
      new Resolver (->), terminate: 3
        .resolve population, ->
          expect population.generationNumber
            .to.equal 3
          done()

    it 'can override termination condition', (done)->
      new Resolver (->), terminate: 3
        .resolve population, terminate: 5, ->
          expect population.generationNumber
            .to.equal 5
          done()

    it 'should terminate when matching any conditions', (done)->
      new Resolver (->), terminate: [
        -> population.generationNumber == 5
        -> population.generationNumber == 3
        ]
      .resolve population, ->
        expect population.generationNumber
          .to.equal 3
        done()
