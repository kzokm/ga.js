'use strict'
{expect} = require 'chai'

utils = require '../../lib/utils'

describe 'samples/TSP', ->
  TSP = require '../tsp'
  it 'should be a function', ->
    expect TSP
      .to.be.a 'function'

  {cities} = require '../data/cities_5.json'
  tsp = new TSP cities

  describe '.Individual', ->
    Individual = tsp.Individual
    it 'should be a function', ->
      expect Individual
        .to.be.a 'function'

    describe '#chromosome', ->
      it 'should be number array, have length same as cities - 1', ->
        individual = new Individual
        chromosome = individual.chromosome
        expect chromosome
          .to.be.an 'array'
          .to.have.length cities.length
        expect chromosome
          .to.satisfy ->
            chromosome.every (gene)-> typeof gene == 'number'

      xit '1st gene should be less than last gene', ->
        individual = new Individual [0, 3, 1, 2]
        chromosome = individual.chromosome
        expect chromosome[0]
          .to.be.lessThan chromosome[2]

      it 'should contain all number between 0 and cities.length - 1', ->
        sequence = [0..cities.length - 1]
        for [0..1000]
          individual = new Individual
          expect individual.chromosome.sort (a,b)-> a - b
            .to.deep.equal sequence

    describe '#fitness', ->
      it 'shold return a number, is greater than 0', ->
        individual = new Individual
        expect individual.fitness
          .to.be.a 'number'
          .is.greaterThan 0

    describe '#route()', ->
      it 'should return a sequece of around cities start from cities[0]', ->
        individual = new Individual [1, 0, 2, 5, 3, 4]
        expect individual.route()
          .to.deep.equal [0, 1, 4, 3, 5, 2, 0]

    describe '#dump()', ->
      it 'should return description string', ->
        individual = new Individual
        expect individual.dump()
          .to.be.a 'string'
          .match /total distance: .*Km around \[.*\]/

  describe '#resolve()', ->
    it 'should resolve problem', (done)->
      tsp.resolve
        N: 50
        G: 100
        Fc: 'OX(1)'
        Pc: 0.95
        Fm: 'inversion()'
        Pm: 0.1
      , (result)->
        console.log result
        expect result.totalDistance.toFixed 3
          .to.equal '184.804'
        expect result.route()
          .to.deep.equal [0, 1, 4, 3, 2, 0]
        done()
