'use strict'
{expect} = require 'chai'

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
          .to.have.length cities.length - 1
        expect chromosome
          .to.satisfy ->
            chromosome.every (gene)-> typeof gene == 'number'

      it 'should contain all number between 1 and cities.length - 1', ->
        sequence = [1..cities.length - 1]
        for [0..1000]
          individual = new Individual
          expect individual.chromosome.sort (a,b)-> a - b
            .to.deep.equal sequence

    describe '#fitness()', ->
      it 'shold return a number, is greater than 0', ->
        individual = new Individual
        expect individual.fitness()
          .to.be.a 'number'
          .is.greaterThan 0

    describe '#route()', ->
      it 'should return a sequece of around cities start from cities[0]', ->
        individual = new Individual [1, 5, 3, 2, 4]
        expect individual.route()
          .to.deep.equal [0, 1, 5, 3, 2, 4, 0]

    describe '#dump()', ->
      it 'should return description string', ->
        individual = new Individual
        expect individual.dump()
          .to.be.a 'string'
          .match /total distance: .*Km around \[.*\]/

  describe '#resolve()', ->
    it 'should resolve problem', (done)->
      tsp.resolve
        N: 100
        G: 50
        Pc: 0.9
        Pm: 0.1
      , (result)->
        expect result.totalDistance.toFixed 3
          .to.equal '184.804'
        route = result.route()
        if route[1] > route[route.length - 2]
          route.reverse()
        expect route
          .to.deep.equal [0, 1, 4, 3, 2, 0]
        done()
