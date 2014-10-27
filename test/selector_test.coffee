'use strict'
{expect} = require 'chai'

describe 'Selector', ->
  Selector = require '../lib/selector'
  it 'should be a function', ->
    expect Selector
      .to.be.a 'function'

  random = require './lib/pesudo_random'
    .attach()

  Popuration = require '../lib/popuration'
  class Individual extends require '../lib/individual'
    fitnessFunction: -> @chromosome

  popuration = new Popuration Individual
    .add new Individual 1
    .add new Individual 2
    .add new Individual 3
    .add new Individual 4
    .add new Individual 5

  describe '.roulette()', ->
    selector = Selector.roulette popuration

    it 'should return a instance of Selector', ->
      expect selector
        .to.be.a.instanceof Selector

    sum = popuration.sum()
    before ->
      expect sum
        .to.equal 15

    describe '#next', ->
      it 'should return a individual', ->
        expect selector.next()
          .to.be.a.instanceof Individual

      it 'can return first individual', ->
        random.push 0 / sum
        expect selector.next()
          .to.equal popuration.get 0

        random.push 1 / sum - (1 - random.MAX_VALUE)
        expect selector.next()
          .to.equal popuration.get 0

      it 'can return 2nd individual', ->
        random.push 1 / sum
        expect selector.next()
          .to.equal popuration.get 1

        random.push (1 + 2) / sum - (1 - random.MAX_VALUE)
        expect selector.next()
          .to.equal popuration.get 1

      it 'can return 2nd individual', ->
        random.push (1 + 2) / sum
        expect selector.next()
          .to.equal popuration.get 2

      it 'can return last individual', ->
        random.push random.MAX_VALUE
        expect selector.next()
          .to.equal popuration.get -1

      it 'should return undefiend if random value is illegal ', ->
        random.push 1
        expect selector.next()
          .to.be.undefined
