'use strict'
{expect} = require 'chai'

describe 'Population', ->
  Population = require '../lib/population'
  it 'should be a function', ->
    expect Population
      .to.be.a 'function'

  Individual = require '../lib/individual'

  population = undefined
  beforeEach ->
    population = new Population Individual
      .add new Individual '001', -> 2
      .add new Individual '002', -> 4
      .add new Individual '003', -> 1
      .add new Individual '004', -> 5
      .add new Individual '005', -> 3


  it 'should have specified number of individuals assigned by constructor', ->
    population = new Population Individual, 100
    expect population.individuals
      .to.have.length 100

    population.individuals.forEach (i)->
      expect i
        .to.be.a.instanceof Individual

  it 'should have property generationNumber initialized by 0', ->
      expect population
        .to.have.property 'generationNumber', 0

  describe '#size()', ->
    it 'should return number of individuals in a population', ->
      expect population.size()
        .to.equal population.individuals.length


  describe '#add()', ->
    beforeEach ->
      population = new Population

    it 'should append specified individual into a population', ->
      population.add new Individual '001'
      expect population.individuals
        .to.have.length 1
        .with.deep.property '[0].chromosome', '001'

      population.add new Individual '002'
      expect population.individuals
        .to.have.length 2
        .with.deep.property '[1].chromosome', '002'

    it 'should return population it self', ->
      expect population.add new Individual
        .to.be.equal population


  describe '#get()', ->
    it 'should return a individual located at specified index in a population', ->
      size = population
      expect population.get 0
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '001'
      expect population.get 1
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '002'

    it 'can accept negative index', ->
      expect population.get -1
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '005'
      expect population.get -2
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '004'

    it 'should return undefined when index is out of bounds', ->
      expect population.get 5
        .to.be.undefined

  describe '#remove()', ->
    it 'should remove individual located at specified index in a population,
        and return a removed individual', ->
      removed = population.remove 2
      expect population.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '003'

    it 'can accept negative index', ->
      removed = population.remove -2
      expect population.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '004'

    it 'should remove a specified individual', ->
      removed = population.remove population.get 2
      expect population.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '003'


  describe '#sample()', ->
    it 'should return a individual that first matched by sampler function', ->
      expect population.sample (i)-> i.chromosome == '004'
        .to.have.property 'chromosome', '004'

      expect population.sample -> true
        .to.have.property 'chromosome', '001'

    it 'should behave same as get if argument is a number', ->
      size = population
      for i in [-4..5]
        expect population.sample i
          .to.equal population.get i

  describe '#sort()', ->
    it 'should sort individuals by fitness value', ->
      population.sort()
      for i in [0..4]
        expect population.get(i).fitness
          .to.equal 5 - i

    it 'should return population it self', ->
      expect population.sort()
        .to.equal population

  describe '#each()', ->
    it 'should return true if any individual mathed by specified function', ->
      str = ''
      population.each (i)-> str += i.chromosome + ','
      expect str
        .to.equal '001,002,003,004,005,'

    it 'should return population it self', ->
      expect population.each -> undefined
        .to.equal population

  describe '#fitness', ->
    describe '#sum()', ->
      it 'should return amount fitness value of all individuals', ->
        expect population.fitness.sum()
          .to.equal 15

    describe '#average()', ->
      it 'should return average fitness value of all individuals', ->
        expect population.fitness.average()
          .to.equal 3

  describe '#best', ->
    it 'should return a first individual', ->
      expect population.best
        .to.equal population.get 0

  describe '#top()', ->
    it 'should return specified number of top individuals', ->
      expect population.top 1
        .to.be.an 'array'
        .with.length 1
        .contain population.get 0

      expect population.top 3
        .to.be.an 'array'
        .with.length 3
        .contain population.get 0
        .contain population.get 1
        .contain population.get 2

  describe '#worst', ->
    it 'should return a last individual', ->
      expect population.worst
        .to.equal population.get -1
