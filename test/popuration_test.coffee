'use strict'
{expect} = require 'chai'

describe 'Popuration', ->
  Popuration = require '../lib/popuration'
  before ->
    expect Popuration
      .to.be.a 'function'

  Individual = require '../lib/individual'

  popuration = undefined
  beforeEach ->
    popuration = new Popuration Individual
      .add new Individual '001', -> 2
      .add new Individual '002', -> 4
      .add new Individual '003', -> 1
      .add new Individual '004', -> 5
      .add new Individual '005', -> 3


  it 'should have specified number of individuals assigned by constructor', ->
    popuration = new Popuration Individual, 100
    expect popuration.individuals
      .to.have.length 100

    popuration.individuals.forEach (i)->
      expect i
        .to.be.a.instanceof Individual


  describe '#size()', ->
    it 'should return number of individuals in a popuration', ->
      popuration = new Popuration Individual, 100
      expect popuration.size()
        .to.equals popuration.individuals.length


  describe '#add()', ->
    beforeEach ->
      popuration = new Popuration

    it 'should append specified individual into a popuration', ->
      popuration.add new Individual '001'
      expect popuration.individuals
        .to.have.length 1
        .with.deep.property '[0].chromosome', '001'

      popuration.add new Individual '002'
      expect popuration.individuals
        .to.have.length 2
        .with.deep.property '[1].chromosome', '002'

    it 'should return popuration it self', ->
      expect popuration.add new Individual
        .to.be.equal popuration


  describe '#get()', ->
    it 'should return a individual located at specified index in a popuration', ->
      size = popuration
      expect popuration.get 0
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '001'
      expect popuration.get 1
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '002'

    it 'can accept negative index', ->
      expect popuration.get -1
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '005'
      expect popuration.get -2
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '004'

    it 'should return undefined when index is out of bounds', ->
      expect popuration.get 5
        .to.be.undefined

  describe '#remove()', ->
    it 'should remove individual located at specified index in a popuration,
        and return a removed individual', ->
      removed = popuration.remove 2
      expect popuration.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '003'

    it 'can accept negative index', ->
      removed = popuration.remove -2
      expect popuration.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '004'

    it 'should remove a specified individual', ->
      removed = popuration.remove popuration.get 2
      expect popuration.individuals
        .to.have.length 4
        .and.not.contain removed
      expect removed
        .to.be.a.instanceof Individual
        .with.property 'chromosome', '003'


  describe '#sample()', ->
    it 'should return a individual that first matched by sampler function', ->
      expect popuration.sample (i)-> i.chromosome == '004'
        .to.have.property 'chromosome', '004'

      expect popuration.sample -> true
        .to.have.property 'chromosome', '001'

    it 'should behave same as get if argument is a number', ->
      size = popuration
      for i in [-4..5]
        expect popuration.sample i
          .to.equal popuration.get i

  describe '#sort()', ->
    it 'should sort individuals by fitness value', ->
      popuration.sort()
      for i in [0..4]
        expect popuration.get(i).fitness()
          .to.equal 5 - i

    it 'should return popuration it self', ->
      expect popuration.sort()
        .to.equal popuration

  describe '#each()', ->
    it 'should return true if any individual mathed by specified function', ->
      str = ''
      popuration.each (i)-> str += i.chromosome + ','
      expect str
        .to.equal '001,002,003,004,005,'

    it 'should return popuration it self', ->
      expect popuration.each -> undefined
        .to.equal popuration

  describe '#sum()', ->
    it 'should return amount fitness value of all individuals', ->
      expect popuration.sum()
        .to.equal 15

  describe '#average()', ->
    it 'should return average fitness value of all individuals', ->
      expect popuration.average()
        .to.equal 3

  describe '#best()', ->
    it 'should return a first individual', ->
      expect popuration.best()
        .to.equal popuration.get 0

  describe '#top()', ->
    it 'should return specified number of top individuals', ->
      expect popuration.top 1
        .to.be.a 'array'
        .with.length 1
        .contain popuration.get 0

      expect popuration.top 3
        .to.be.a 'array'
        .with.length 3
        .contain popuration.get 0
        .contain popuration.get 1
        .contain popuration.get 2

  describe '#worst()', ->
    it 'should return a last individual', ->
      expect popuration.worst()
        .to.equal popuration.get -1
