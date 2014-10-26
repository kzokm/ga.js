'use strict'
{expect, assert} = require 'chai'

Crossover = require '../lib/crossover_operator'
random = require './lib/pesudo_random'

describe 'CrossoverOperator', ->
  random = require './lib/pesudo_random'
    .attach()

  wrap = (operator)-> (args...)->
    before = args.map (e)-> e.concat()
    result = operator arguments...
    expect args, 'Arguments was broken while operation.'
      .to.deep.equals before
    result

  describe '#point 1', ->
    crossover = Crossover.point 1

    before ->
      expect crossover
        .to.be.a 'function'
      crossover = wrap crossover

    it 'can crossover all genes', ->
      random.push 0
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

    it 'can crossover after 2nd locus', ->
      random.push 1/5
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['A', 'b', 'c', 'd', 'e'], ['a', 'B', 'C', 'D', 'E']]

    it 'can crossover last gene only', ->
      random.push random.MAX
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

  describe '#point 2', ->
    crossover = Crossover.point 2

    before ->
      expect crossover
        .to.be.a 'function'
      crossover = wrap crossover

    it 'can crossover 1st gene only', ->
      random.push 0, 0
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'B', 'C', 'D', 'E'], ['A', 'b', 'c', 'd', 'e']]

    it 'can crossover last gene only', ->
      random.push 4/5, random.MAX
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

    it 'can crossover all genes', ->
      random.push 0, random.MAX
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

    it 'can crossover middle locus genes', ->
      random.push 1/5, 3/5
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['A', 'b', 'c', 'd', 'E'], ['a', 'B', 'C', 'D', 'e']]

      random.push 3/5, 1/5
      expect crossover ['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']
        .to.deep.equals [['a', 'B', 'C', 'D', 'e'], ['A', 'b', 'c', 'd', 'E']]

  describe '#uniform', ->
    crossover = Crossover.uniform()
    probability = 0.5
    YES = random.MAX - probability
    NO = probability

    before ->
      expect crossover
        .to.be.a 'function'
      crossover = wrap crossover

    it 'can crossover 1st gene only', ->
      random.push YES, NO, NO, NO, NO
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'B', 'C', 'D', 'E'], ['A', 'b', 'c', 'd', 'e']]

    it 'can crossover last gene only', ->
      random.push NO, NO, NO, NO, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['A', 'B', 'C', 'D', 'e'], ['a', 'b', 'c', 'd', 'E']]

    it 'can crossover half genes', ->
      random.push YES, NO, YES, NO, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'B', 'c', 'D', 'e'], ['A', 'b', 'C', 'd', 'E']]

    it 'can crossover all genes', ->
      random.push YES, YES, YES, YES, YES
      expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
        .to.deep.equals [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]

  describe '#uniform 0.0', ->
    crossover = Crossover.uniform 0.0

    it 'should never crossover', ->
      for [0..1000]
        expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
          .to.deep.equals [['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']]

  describe '#uniform 1.0', ->
    crossover = Crossover.uniform 1.0

    it 'should always crossover all genes', ->
      for [0..1000]
        expect crossover ['A', 'B', 'C', 'D', 'E'], ['a', 'b', 'c', 'd', 'e']
          .to.deep.equals [['a', 'b', 'c', 'd', 'e'], ['A', 'B', 'C', 'D', 'E']]