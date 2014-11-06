'use strict'
{expect} = require 'chai'

describe 'samples/Knapsack', ->
  Knapsack = require '../knapsack'
  it 'should be a function', ->
    expect Knapsack
      .to.be.a 'function'

  capacity = 10
  {items} = require '../data/items_10.json'
  knapsack = new Knapsack capacity, items

  before ->
    expect items
      .to.be.an 'array'
      .with.length 10

  describe '.Individual', ->
    Individual = knapsack.Individual
    it 'should be a function', ->
      expect Individual
        .to.be.a 'function'

    describe '#chromosome', ->
      it 'should be boolean array, have length same as items', ->
        individual = new Individual
        chromosome = individual.chromosome
        expect chromosome
          .to.be.an 'array'
          .to.have.length items.length
        expect chromosome
          .to.satisfy ->
            chromosome.every (gene)-> typeof gene == 'boolean'

      it 'should be initialized by constructor', ->
        chromosome = new Array
        individual = new Individual chromosome
        expect individual.chromosome
          .to.equal chromosome

    describe '#fitness()', ->
      it 'shold return a number, is greater than 0', ->
        individual = new Individual []
        expect individual.fitness()
          .to.be.a 'number'
          .is.greaterThan 0

    describe '#dump()', ->
      it 'should return description string', ->
        individual = new Individual
        expect individual.dump()
          .to.be.a 'string'
          .match /amount prices: \$.*, .*Kg of \[.*\]/

  describe '#resolve()', ->
    it 'should resolve problem', (done)->
      knapsack.resolve
        N: 100
        G: 50
        Pc: 0.9
        Pm: 0.1
      , (result)->
        expect result.price
          .to.equal 18.15
        expect result.weight
          .to.equal 9.9
        expect result.itemNumbers
          .to.deep.equal [2, 4, 6, 7]
        done()
