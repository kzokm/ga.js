'use strict'
{expect} = require 'chai'

describe 'Individual', ->
  Individual = require '../lib/individual'
  it 'should be a function', ->
    expect Individual
      .to.be.a 'function'

  describe '#chromosome', ->
    it 'should be a chromosome value assigned by constuctor', ->
      individual = new Individual 'ABC'
      expect individual
        .to.have.property 'chromosome', 'ABC'

  describe '#fitness', ->
    class IndividualWithFitnessFunction extends Individual
      fitnessFunction: -> "f(#{@chromosome})"

    it 'should be readonly', ->
      individual= new Individual
      expect -> individual.fitness = 0
        .to.throw TypeError, 'which has only a getter'

    it 'should be fitness value calculated by fitness function', ->
      individual = new IndividualWithFitnessFunction 'ABC'
      expect individual.fitness
        .to.equal 'f(ABC)'

    it 'can be personalized fitness value instead of prototyped function', ->
      individual = new IndividualWithFitnessFunction 'ABC', -> 999
      expect individual.fitness
        .to.equal 999

    it 'should throw error if not defined fitnessFunction', ->
      expect -> (new Individual 'ABC').fitness
        .to.throw TypeError, /has no method/

    it 'should cache latest value', ->
      individual = new IndividualWithFitnessFunction 'ABC'
      expect individual.fitness
        .to.equal 'f(ABC)'

      individual.chromosome = 'XYZ'
      expect individual.fitness
        .to.equal 'f(ABC)'

      individual._fitnessValue = undefined
      expect individual.fitness
        .to.equal 'f(XYZ)'
