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
        indexes = [1..cities.length - 1]
        for val, i in indexes
          j = i + GA.randomInt(indexes.length - i)
          indexes[i] = indexes[j]
          indexes[j] = val
        indexes

      fitnessFunction: ->
        start = goal = prev = 0
        @totalDistance = 0
        for next in @chromosome
          @totalDistance += distanceBetween prev, next
          prev = next
        @totalDistance += distanceBetween prev, goal

      distanceBetween = (i, j)->
        Math.sqrt (cities[i].x - cities[j].x) ** 2 + (cities[i].y - cities[j].y) ** 2

      route: ->
        [].concat 0, @chromosome, 0

      dump: ->
        @fitness
        "total distance: #{@totalDistance.toFixed 3}Km around [#{@route()}]"

  class Popuration extends GA.Popuration
    comparator: Popuration.comparator.asc

  resolve: (config, callback)->
    crossover = eval "GA.Crossover.#{config.Fc}"
    mutator = eval "GA.Mutation.#{config.Fm}"

    config.reproduct = (popuration)->
      elites = popuration.best
      selector = GA.Selector.tournament popuration, 4
      offsprings = for [1..popuration.size() / 2]
        @Individual.pair selector
          .crossover config.Pc, crossover
          .mutate config.Pm, mutator
          .offsprings
      popuration.set [].concat offsprings...
      popuration.add elites

    config.terminate = [
        config.G
        (popuration)->
          popuration.best.fitness == popuration.fitness.average()
      ]

    super (new Popuration @Individual, config.N), config, callback



if window?
  window.TSP = TSP
else
  module.exports = TSP
