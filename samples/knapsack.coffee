# Knapsack Problem Resolver
#   chromosome: array of boolean to pick a item or not
#   locus: index of items

GA = if window? then window.GA else require '../lib/index'

class Knapsack extends GA.Resolver
  constructor: (capacity, items)->
    class @Individual extends GA.Individual
      constructor: (chromosome)->
        chromosome ?= for [1..items.length]
          Math.random() * items.length < 3
        super chromosome

      fitnessFunction: ->
        @itemNumbers = []
        @weight = @price = 0
        for picked, i in @chromosome
          if picked and capacity >= @weight + items[i].weight
            @itemNumbers.push i + 1
            @weight += items[i].weight
            @price += items[i].price
          break if @weight == capacity
        @itemNumbers.sort (a, b)-> a - b
        @price + @fitnessOffset

      fitnessOffset: 0.1

      dump: ->
        @fitness
        "amount prices: $#{@price.toFixed 2}, #{@weight.toFixed 1}Kg of [#{@itemNumbers}] / #{@itemNumbers.length}"

  resolve: (config, callback)->
    crossover = eval "GA.Crossover.#{config.Fc}"
    mutator = eval "GA.Mutation.#{config.Fm}"

    config.reproduct = (population)->
      selector = GA.Selector.roulette population
      elites = population.best
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

    super (new GA.Population @Individual, config.N), config, callback

if window?
  window.Knapsack = Knapsack
else
  module.exports = Knapsack
