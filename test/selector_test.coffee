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
    .add new Individual 3
    .add new Individual 5
    .add new Individual 4
    .add new Individual 2

  describe '.roulette()', ->
    selector = Selector.roulette popuration

    it 'should return a instance of Selector', ->
      expect selector
        .to.be.a.instanceof Selector

    sum = popuration.sum()
    before ->
      expect sum
        .to.equal 15

    probability = (n)->
      if n < 0
        (probability -n) - (1 - random.MAX_VALUE)
      else if n == 0
        0
      else ((
        for i in [0..n - 1]
          popuration.get i
            .fitness
        ).reduce (sum, f)->
          sum += f
        ) / sum

    describe '#next', ->
      it 'should return a individual', ->
        expect selector.next()
          .to.be.a.instanceof Individual

      it 'can return 1st individual', ->
        random.push probability 0
        expect selector.next()
          .to.equal popuration.get 0

        random.push probability -1
        expect selector.next()
          .to.equal popuration.get 0

      it 'can return 2nd individual', ->
        random.push probability 1
        expect selector.next()
          .to.equal popuration.get 1

        random.push probability -2
        expect selector.next()
          .to.equal popuration.get 1

      it 'can return 3rd individual', ->
        random.push probability 2
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

  describe '.tournament()', ->
    selector = Selector.tournament popuration

    it 'should return a instance of Selector', ->
      expect selector
        .to.be.a.instanceof Selector

    it 'should have default size 4', ->
      expect selector.size
        .to.equal 4
        .to.equal Selector.tournament.defaultSize

    probability = (n)->
      if n < 0
        (probability -n) - (1 - random.MAX_VALUE)
      else if n == 0
        0
      else
        n / popuration.size()

    describe '#next', ->
      it 'can return 1st individual', ->
        for [1..selector.size]
          random.push probability 0
        random.push probability 1 # one more probability
        expect selector.next()
          .to.equal popuration.get 0

      it 'can return 2nd individual', ->
        for [1..selector.size - 1]
          random.push probability 0
        random.push probability 1
        expect selector.next()
          .to.equal popuration.get 1

      it 'can return last individual', ->
        for [1..selector.size - 1]
          random.push probability 0
        random.push random.MAX_VALUE
        expect selector.next()
          .to.equal popuration.get -1

      it 'should return undefiend if random value is illegal ', ->
        for [1..selector.size]
          random.push 1
        expect selector.next()
          .to.be.undefined
