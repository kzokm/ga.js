###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

require './utils'

class Individual
  constructor: (@chromosome, fitnessFunction)->
    @fitnessFunction = fitnessFunction if fitnessFunction?

  @property 'fitness',
    get: -> @_fitnessValue ?= @fitnessFunction @chromosome

  mutate: (operator)->
    if typeof operator != 'function'
      throw TypeError "Mutation operator is not function: #{operator}"
    @chromosome = operator @chromosome
    @_fitnessValue = undefined
    @

  @pair: (selector)->
    new @Pair @, selector

  @Pair: class
    constructor: (@Individual, selector)->
      @parents = [selector.next(), selector.next()]

    crossover: (probability, operator, parents = @parents)->
      if typeof operator != 'function'
        throw TypeError "Crossover operator is not function: #{operator}"
      @offsprings = if Math.random() < probability
        operator.apply @, parents.map (i)-> i.chromosome
          .map (c)=> new @Individual c
      else
        parents
          .map (i)=> new @Individual i.chromosome[...]
      @

    mutate: (probability, operator, targets = @offsprings)->
      if typeof operator != 'function'
        throw TypeError "Mutation operator is not function: #{operator}"
      targets.forEach (i)->
        if Math.random() < probability
          i.mutate operator
      @

module.exports = Individual
