'use strict'
{expect} = require 'chai'

describe 'Individual', ->
  Individual = require '../lib/individual'
  before ->
    expect Individual
      .to.be.a 'function'

  describe '#chromosome', ->
    it 'should have property chromosome assigned by constuctor', ->
      individual = new Individual 'ABC'
      expect individual
        .to.have.property 'chromosome', 'ABC'

  describe '#fitness()', ->
    class IndividualWithFitnessFunction extends Individual
      fitnessFunction: -> "f(#{@chromosome})"

    it 'should return fitness value calculated by fitness function', ->
      individual = new IndividualWithFitnessFunction 'ABC'
      expect individual.fitness()
        .to.equals 'f(ABC)'

    it 'can return personalized fitness value instead of prototyped function', ->
      individual = new IndividualWithFitnessFunction 'ABC', -> 999
      expect individual.fitness()
        .to.equals 999

    it 'should throw error if not defined fitnessFunction', ->
      expect -> (new Individual 'ABC').fitness()
        .to.throw TypeError, /has no method/

    it 'should cache fitness value', ->
      individual = new IndividualWithFitnessFunction 'ABC'
      expect individual.fitness()
        .to.equals 'f(ABC)'

      individual.chromosome = 'XYZ'
      expect individual.fitness()
        .to.equals 'f(ABC)'

      individual._fitnessValue = undefined
      expect individual.fitness()
        .to.equals 'f(XYZ)'
