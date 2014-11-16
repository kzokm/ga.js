# Travelling Salesman Problem Resolver
#   chromosome: array of index number of cities without 0
#   locus: sequence of route

GA = if window? then @GA else require '../lib/index'

class TSP extends GA.Resolver
  constructor: (cities)->
    class @Individual extends GA.Individual
      constructor: (chromosome)->
        super chromosome ?= randomRoute cities

      randomRoute = (cities)->
        GA.scramble [0..cities.length - 1]

      fitnessFunction: ->
        @totalDistance = 0
        prev = @chromosome[@chromosome.length - 1]
        for next in @chromosome
          @totalDistance += distanceBetween prev, next
          prev = next
        @totalDistance

      distanceBetween = (i, j)->
        Math.sqrt (cities[i].x - cities[j].x) ** 2 + (cities[i].y - cities[j].y) ** 2

      route: ->
        route = [].concat @chromosome
        route = GA.rotate route, route.indexOf 0
        route.push 0
        if route[1] > route[route.length - 2]
          route.reverse()
        route

      dump: ->
        @fitness
        "total distance: #{@totalDistance.toFixed 3}Km around [#{@route()}]"


  class Population extends GA.Population
    comparator: Population.comparator.asc

  resolve: (config, callback)->
    crossover = eval "GA.Crossover.#{config.Fc}"
    mutator = eval "GA.Mutation.#{config.Fm}"

    config.reproduct = (population)->
      elites = population.best
      selector = GA.Selector.tournament population, 4
      offsprings = for [1..population.size() / 2]
        @Individual.pair selector
          .crossover config.Pc, crossover
          .mutate config.Pm, mutator
          .offsprings
      population.set [].concat offsprings...
      population.add elites

    config.terminate = [
        config.G
        (population)->
          population.best.fitness == population.fitness.average()
      ]

    super (new Population @Individual, config.N), config, callback



if window?
  window.TSP = TSP
else
  module.exports = TSP
