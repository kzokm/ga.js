'use strict'

{expect} = require 'chai'

describe 'MutationOperator', ->
  Mutation = require '../lib/mutation_operator'
  it 'should be a function', ->
    expect Mutation
      .to.be.a 'function'

  random = require './lib/pesudo_random'
    .attach()

  describe '.booleanInversion()', ->
    mutate = Mutation.booleanInversion()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'can mutate false to true', ->
      expect mutate [false]
        .to.deep.equal [true]

    it 'can mutate true to false', ->
      expect mutate [true]
        .to.deep.equal [false]

  describe '.binaryInversion()', ->
    mutate = Mutation.binaryInversion()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'can mutate 0 to 1', ->
      expect mutate [0]
        .to.deep.equal [1]

    it 'can mutate 1 to 0', ->
      expect mutate [1]
        .to.deep.equal [0]

    it 'can mutate first gene', ->
      random.set 0
      expect mutate [0, 0, 0]
        .to.deep.equal [1, 0, 0]

    it 'can mutate middle locus gene', ->
      random.set 1/3
      expect mutate [1, 1, 1]
        .to.deep.equal [1, 0, 1]

    it 'can mutate last gene', ->
      random.set random.MAX_VALUE
      expect mutate [0, 0, 1]
        .to.deep.equal [0, 0, 0]

  describe '.substitution()', ->
    mutate = Mutation.substitution (ch)->
      ch.toLowerCase()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'can mutate first gene', ->
      random.set 0
      expect mutate ['A', 'B', 'C']
        .to.deep.equal ['a', 'B', 'C']

  describe '.swap()', ->
    mutate = Mutation.swap()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'can swap 1st and last genes', ->
      random.set 0/5, random.MAX_VALUE
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equal [5, 2, 3, 4, 1]

    it 'can swap 2nd and 4th genes', ->
      random.set 1/5, 3/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equal [1, 4, 3, 2, 5]

    it 'can swap 4th and 2nd genes', ->
      random.set 3/5, 1/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equal [1, 4, 3, 2, 5]


  describe '.reverse()', ->
    mutate = Mutation.reverse()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'should be same as inversion', ->
      expect mutate.toString()
        .to.equal Mutation.inversion().toString()

  describe '.inversion()', ->
    mutate = Mutation.inversion()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'can reverse all genes', ->
      random.set 0, random.MAX_VALUE
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equal [5, 4, 3, 2, 1]

      random.set random.MAX_VALUE, 0
      expect mutate [5, 4, 3, 2, 1]
        .to.deep.equal [1, 2, 3, 4, 5]

    it 'can reverse middle locus genes', ->
      random.set 1/5, 3/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equal [1, 4, 3, 2, 5]

      random.set 3/5, 1/5
      expect mutate [5, 4, 3, 2, 1]
        .to.deep.equal [5, 2, 3, 4, 1]
