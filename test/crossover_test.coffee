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


  # Single point crossover operation
  describe '.point 1', ->
    crossover = Crossover.point 1

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 1
      crossover = injectArgumentsAssertion crossover

    it 'can swap all genes', ->
      random.push 0
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'],
                        ['A', 'B', 'C', 'D', 'E']]

    it 'can swap after 2nd locus', ->
      random.push 1/5
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'b', 'c', 'd', 'e'],
                        ['a', 'B', 'C', 'D', 'E']]

    it 'can swap last gene only', ->
      random.push random.MAX_VALUE
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'],
                        ['a', 'b', 'c', 'd', 'E']]


  # Two point crossover operation
  describe '.point 2', ->
    crossover = Crossover.point 2

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 2
      crossover = injectArgumentsAssertion crossover

    it 'can swap 1st gene only', ->
      random.push 0, 0
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'C', 'D', 'E'],
                        ['A', 'b', 'c', 'd', 'e']]

    it 'can swap last gene only', ->
      random.push 4/5, random.MAX_VALUE
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'],
                        ['a', 'b', 'c', 'd', 'E']]

    it 'can swap all genes', ->
      random.push 0, random.MAX_VALUE
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'],
                        ['A', 'B', 'C', 'D', 'E']]

    it 'can swap middle locus genes', ->
      random.push 1/5, 3/5
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'b', 'c', 'd', 'E'],
                        ['a', 'B', 'C', 'D', 'e']]

      random.push 3/5, 1/5
      expect crossover  ['a', 'b', 'c', 'd', 'e'],
                        ['A', 'B', 'C', 'D', 'E']
        .to.deep.equal [['a', 'B', 'C', 'D', 'e'],
                        ['A', 'b', 'c', 'd', 'E']]


  # Uniform crossover operation
  describe '.uniform()', ->
    crossover = Crossover.uniform()
    probability = 0.5
    YES = random.MAX_VALUE - probability
    NO = probability

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'probability', probability
      crossover = injectArgumentsAssertion crossover

    it 'can swap 1st gene only', ->
      random.push YES, NO, NO, NO, NO
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'C', 'D', 'E'],
                        ['A', 'b', 'c', 'd', 'e']]

    it 'can swap last gene only', ->
      random.push NO, NO, NO, NO, YES
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['A', 'B', 'C', 'D', 'e'],
                        ['a', 'b', 'c', 'd', 'E']]

    it 'can swap half genes', ->
      random.push YES, NO, YES, NO, YES
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'B', 'c', 'D', 'e'],
                        ['A', 'b', 'C', 'd', 'E']]

    it 'can swap all genes', ->
      random.push YES, YES, YES, YES, YES
      expect crossover  ['A', 'B', 'C', 'D', 'E'],
                        ['a', 'b', 'c', 'd', 'e']
        .to.deep.equal [['a', 'b', 'c', 'd', 'e'],
                        ['A', 'B', 'C', 'D', 'E']]

  describe '.uniform 0.0', ->
    crossover = Crossover.uniform 0.0

    it 'should never crossover', ->
      expect crossover
        .to.have.property 'probability', 0
      for [0..1000]
        expect crossover  ['A', 'B', 'C', 'D', 'E'],
                          ['a', 'b', 'c', 'd', 'e']
          .to.deep.equal [['A', 'B', 'C', 'D', 'E'],
                          ['a', 'b', 'c', 'd', 'e']]

  describe '.uniform 1.0', ->
    crossover = Crossover.uniform 1.0

    it 'should always crossover all genes', ->
      expect crossover
        .to.have.property 'probability', 1

      for [0..1000]
        expect crossover  ['A', 'B', 'C', 'D', 'E'],
                          ['a', 'b', 'c', 'd', 'e']
          .to.deep.equal [['a', 'b', 'c', 'd', 'e'],
                          ['A', 'B', 'C', 'D', 'E']]


  # Order crossover operation
  describe '.OX 1', ->
    crossover = Crossover.OX 1

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 1
      crossover = injectArgumentsAssertion crossover

    it 'can swap all genes', ->
      random.push 0
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[2, 5, 4, 1, 3],
                        [1, 3, 2, 4, 5]]

    it 'can keep 1st gene and swap others', ->
      random.push 1/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 2, 5, 4, 3],
                        [2, 1, 3, 4, 5]]

    it 'can keep 2 genes and swap others', ->
      random.push 2/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 3, 2, 5, 4],
                        [2, 5, 1, 3, 4]]

    it 'can keep all genes', ->
      random.push 4/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]]

  describe '.order()', ->
    it 'should same as .OX', ->
      expect Crossover.order
        .to.equal Crossover.OX


  describe '.OX 2', ->
    crossover = Crossover.OX 2

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 2
      crossover = injectArgumentsAssertion crossover

    it 'can swap all genes', ->
      random.push 0, 0
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[2, 5, 4, 1, 3],
                        [1, 3, 2, 4, 5]]

    it 'can keep 1st gene and swap others', ->
      random.push 0, 1/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 2, 5, 4, 3],
                        [2, 1, 3, 4, 5]]

    it 'can keep 2nd and 3rd genes and swap others', ->
      random.push 1/5, 2/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 3, 2, 5, 4],
                        [1, 5, 4, 3, 2]]

    it 'can keep all genes', ->
      random.push 0, 4/5
      expect crossover  [1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]
        .to.deep.equal [[1, 3, 2, 4, 5],
                        [2, 5, 4, 1, 3]]



  # Cycle crossover operation
  describe '.CX()', ->
    crossover = Crossover.CX()

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
      crossover = injectArgumentsAssertion crossover

    it 'can swap some genes', ->
      random.push 5/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[2, 5, 1, 3, 4, 6],
                        [1, 6, 3, 2, 5, 4]]

    it 'should keep all genes if cyclic at once', ->
      random.push 0
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 4, 5, 1, 3]
        .to.deep.equal [[1, 5, 3, 2, 4, 6],
                        [2, 6, 4, 5, 1, 3]]

  describe '.cycle()', ->
    it 'should same as .CX', ->
      expect Crossover.cycle
        .to.equal Crossover.CX


  # Partially-mapped crossover operation
  describe '.PMX 1', ->
    crossover = Crossover.PMX 1

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 1
      crossover = injectArgumentsAssertion crossover

    it 'can swap all genes', ->
      random.push 0/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[2, 6, 1, 3, 5, 4],
                        [1, 5, 3, 2, 4, 6]]

    it 'can swap some genes', ->
      random.push 2/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[1, 5, 2, 3, 6, 4],
                        [2, 6, 3, 1, 4, 5]]

    it 'can keep all genes', ->
      random.push 5/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]]


  describe '.PMX 2', ->
    crossover = Crossover.PMX 2

    it 'should return a function', ->
      expect crossover
        .to.be.a 'function'
        .with.property 'n', 2
      crossover = injectArgumentsAssertion crossover

    it 'can swap all genes', ->
      random.push 0, 0/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[2, 6, 1, 3, 5, 4],
                        [1, 5, 3, 2, 4, 6]]

    it 'can swap some genes', ->
      random.push 2/6, 2/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[1, 6, 3, 2, 5, 4],
                        [2, 5, 1, 3, 4, 6]]

    it 'can keep all genes', ->
      random.push 0, 5/6
      expect crossover  [1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]
        .to.deep.equal [[1, 5, 3, 2, 4, 6],
                        [2, 6, 1, 3, 5, 4]]
