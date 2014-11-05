
class @Knapsack extends GA.Resolver
  constructor: (capacity, items)->
    super
    class @Individual extends GA.Individual
      constructor: (chromosome)->
        chromosome ?= for [1..items.length]
          Math.random() * items.length < 3
        super chromosome

      fitnessFunction: ->
        @weight = @price = 0
        for selected, i in @chromosome
          if selected and capacity >= @weight + items[i].weight
            @weight += items[i].weight
            @price += items[i].price
          break if @weight == capacity
        @price + @finessOffset

      finessOffset: 0.1

      selected: ->
        amount = 0
        @_selected ?= @chromosome
          .map (e, i)-> i + 1 if e
          .filter (i)-> i?
          .filter (i)->
            if amount + items[i - 1].weight <= capacity
              amount += items[i - 1].weight
              true
          .sort (a, b)-> a - b

      dump: ->
        "amount prices: $#{@price.toFixed 2}, #{@weight.toFixed 1}Kg of [#{@selected()}] / #{@selected().length}"

  resolve: (config, callback)->
    crossover = GA.Crossover.point 2
    mutator = GA.Mutation.binaryInversion()

    config.reproduct = (popuration)->
      selector = GA.Selector.roulette popuration
      elites = popuration.best()
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
          popuration.best().fitness() == popuration.average()
      ]

    super (new GA.Popuration @Individual, config.N), config, callback
