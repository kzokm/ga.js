'use strict'
{expect} = require 'chai'

describe 'CrossoverOperator', ->
  Crossover = require '../lib/crossover_operator'
  it 'should be a function', ->
    expect Crossover
      .to.be.a 'function'

  random = require './lib/pesudo_random'
    .attach()

  injectArgumentsAssertion = (operator)-> (args...)->
    before = args.map (e)-> e.concat()
    result = operator arguments...
    expect args, 'Arguments were broken while operation.'
      .to.deep.equal before
    result

  describe '.point 1', ->
    crossover = Crossover.point 1

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
      crossover = injectArgumentsAssertion crossover

    it 'can exchange all genes', ->
      random.push 0
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

    it 'can exchange after 2nd locus', ->
      random.push 1/5
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'b', 'c', 'd', 'e'], ['a', 'B', 'C', 'D', 'E']]

    it 'can exchange last gene only', ->
      random.push random.MAX_VALUE
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

  describe '.point 2', ->
    crossover = Crossover.point 2

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
      crossover = injectArgumentsAssertion crossover

    it 'can exchange 1st gene only', ->
      random.push 0, 0
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'C', 'D', 'E'], ['A', 'b', 'c', 'd', 'e']]

    it 'can exchange last gene only', ->
      random.push 4/5, random.MAX_VALUE
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

    it 'can exchange all genes', ->
      random.push 0, random.MAX_VALUE
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

    it 'can exchange middle locus genes', ->
      random.push 1/5, 3/5
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'b', 'c', 'd', 'E'], ['a', 'B', 'C', 'D', 'e']]

      random.push 3/5, 1/5
      expect crossover ['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']
        .to.deep.equal [['a', 'B', 'C', 'D', 'e'], ['A', 'b', 'c', 'd', 'E']]


  describe '.uniform()', ->
    crossover = Crossover.uniform()
    probability = 0.5
    YES = random.MAX_VALUE - probability
    NO = probability

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
      crossover = injectArgumentsAssertion crossover

    it 'can exchange 1st gene only', ->
      random.push YES, NO, NO, NO, NO
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'C', 'D', 'E'], ['A', 'b', 'c', 'd', 'e']]

    it 'can exchange last gene only', ->
      random.push NO, NO, NO, NO, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

    it 'can exchange half genes', ->
      random.push YES, NO, YES, NO, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'c', 'D', 'e'], ['A', 'b', 'C', 'd', 'E']]

    it 'can exchange all genes', ->
      random.push YES, YES, YES, YES, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

  describe '.uniform 0.0', ->
    crossover = Crossover.uniform 0.0

    it 'should never crossover', ->
      for [0..1000]
        expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
          .to.deep.equal [['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']]

  describe '.uniform 1.0', ->
    crossover = Crossover.uniform 1.0

    it 'should always crossover all genes', ->
      for [0..1000]
        expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
          .to.deep.equal [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]


  describe '.OX()', ->
    crossover = Crossover.OX()

    it 'should return a function same as order()', ->
      expect crossover
        .to.be.a 'function'
      crossover = injectArgumentsAssertion crossover

    it 'can exchange all genes', ->
      random.push 0
      expect crossover [1, 3, 2, 4, 5], [2, 5, 4, 1, 3]
        .to.deep.equal [[2, 5, 4, 1, 3], [1, 3, 2, 4, 5]]

    it 'can keep 1st gene and exchange others', ->
      random.push 1/5
      expect crossover [1, 3, 2, 4, 5], [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 2, 5, 4, 3], [2, 1, 3, 4, 5]]

    it 'can keep 2 genes and exchange others', ->
      random.push 2/5
      expect crossover [1, 3, 2, 4, 5], [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 3, 2, 5, 4], [2, 5, 1, 3, 4]]

  describe '.order()', ->
    it 'should same as .OX', ->
      expect Crossover.order
        .to.equal Crossover.OX
