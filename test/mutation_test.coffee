'use strict'

{expect} = require 'chai'

describe 'MutationOperator', ->
  Mutation = require '../lib/mutation_operator'
  before ->
    expect Mutation
      .to.be.a 'object'

  random = require './lib/pesudo_random'
    .attach()

  describe '#binaryInversion', ->
    mutate = Mutation.binaryInversion()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'mutate first gene', ->
      random.set 0
      expect mutate [0, 0, 0]
        .to.deep.equals [1, 0, 0]

    it 'mutate middle locus gene', ->
      random.set 1/3
      expect mutate [1, 1, 1]
        .to.deep.equals [1, 0, 1]

    it 'mutate last gene', ->
      random.set random.MAX
      expect mutate [0, 0, 1]
        .to.deep.equals [0, 0, 0]

  describe '#substitution', ->
    mutate = Mutation.substitution (ch)->
      ch.toLowerCase()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'mutate first gene', ->
      random.set 0
      expect mutate ['A', 'B', 'C']
        .to.deep.equals ['a', 'B', 'C']

  describe '#exchange', ->
    mutate = Mutation.exchange()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'exchange 1st and last genes', ->
      random.set 0/5, random.MAX
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equals [5, 2, 3, 4, 1]

    it 'exchange 2nd and 4th genes', ->
      random.set 1/5, 3/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equals [1, 4, 3, 2, 5]

    it 'exchange 4th and 2nd genes', ->
      random.set 3/5, 1/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equals [1, 4, 3, 2, 5]

  describe '#reverse', ->
    mutate = Mutation.reverse()

    it 'should return a function', ->
      expect mutate
        .to.be.a 'function'

    it 'reverse all genes', ->
      random.set 0, random.MAX
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equals [5, 4, 3, 2, 1]

      random.set random.MAX, 0
      expect mutate [5, 4, 3, 2, 1]
        .to.deep.equals [1, 2, 3, 4, 5]

    it 'reverse middle locus genes', ->
      random.set 1/5, 3/5
      expect mutate [1, 2, 3, 4, 5]
        .to.deep.equals [1, 4, 3, 2, 5]

      random.set 3/5, 1/5
      expect mutate [5, 4, 3, 2, 1]
        .to.deep.equals [5, 2, 3, 4, 1]
