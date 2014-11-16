'use strict'
{expect,AssertionError} = require 'chai'

describe 'Individual.pair', ->
  Population = require '../lib/population'
  class Individual extends require '../lib/individual'
    constructor: (chromosome)->
      chromosome = Array::slice.apply chromosome
        .map (g)-> parseInt g
      super chromosome
    fitnessFunction: ->
      @chromosome.reduce (i, j)-> i + j

  population = new Population Individual
    .add new Individual '0001'
    .add new Individual '0010'
    .add new Individual '0100'
    .add new Individual '1000'

  Selector = require '../lib/selector'
  selector = Selector.roulette population


  random = require './lib/pesudo_random'
    .attach()

  pair = undefined
  beforeEach ->
    random.push 0, random.MAX_VALUE
    pair = Individual.pair selector

  it 'should return a instance of Individual.Pair', ->
    expect pair
      .to.be.a.instanceof Individual.Pair
   describe '#parents', ->
    it 'shold be a array, that contain pair of individuals', ->
      expect pair.parents
        .to.be.an 'array'
        .that.have.length 2
        .with.contain population.get 0
        .and.contain population.get -1


  describe '#crossover()', ->
    it 'shold return pair it self', ->
      expect pair.crossover 0, (->)
        .to.equal pair

    it 'should create property offsprings', ->
      expect pair
        .to.not.have.property 'offsprings'
      pair.crossover 0, (->)
      expect pair
        .to.have.property 'offsprings'


    describe '#offsprings', ->
      it 'should contains new individuals created from parents via crossover opeartor', ->
        pair.crossover 1.0, ->
          expect arguments
            .that.have.length 2
          for i in [0..1]
            expect arguments[i]
              .to.equal pair.parents[i].chromosome
          ['0000', '1111']

        expect pair.offsprings
          .to.be.an 'array'
          .that.have.length 2
        for i in [0..1]
          expect pair.offsprings[i]
            .to.be.a.instanceof Individual
          expect pair.offsprings[i].chromosome
            .to.deep.equal [i, i, i, i]

      it 'should contains clone of parents if not enough probability', ->
        pair.crossover 0, ->
          throw new AssertionError 'crossover operator should not call'

        expect pair.offsprings
          .to.be.an 'array'
          .that.have.length 2
          .and.not.equal pair.parents
        for i in [0..1]
          expect pair.offsprings[i]
            .to.be.a.instanceof Individual
            .that.not.equal pair.parents[i]
          expect pair.offsprings[i].chromosome
            .to.deep.equal pair.parents[i].chromosome
          expect pair.offsprings[i].chromosome
            .to.not.equal pair.parents[i].chromosome


  describe '#mutate()', ->
    beforeEach ->
      pair.offsprings = [new Individual '0000']

    it 'shold return pair it self', ->
      expect pair.mutate 0, (->)
        .to.equal pair

    it 'should mutate offsprings and rewrite chromosome directory', ->
      offspring = pair.offsprings[0]
      expect offspring.chromosome
        .to.deep.equal [0, 0, 0, 0]
      expect offspring.fitness
        .to.equal 0

      pair.mutate 1, ->
        expect arguments
          .that.have.length 1
        expect arguments[0]
          .to.deep.equal [0, 0, 0, 0]
        [1, 1, 1, 1]

      expect pair.offsprings
        .to.deep.equal [offspring]
      expect offspring.chromosome
        .to.deep.equal [1, 1, 1, 1]
      expect offspring.fitness
        .to.equal 4

    it 'should not work if not enough probability', ->
      pair.mutate 0, ->
        throw new AssertionError 'mutation operator should not call'
