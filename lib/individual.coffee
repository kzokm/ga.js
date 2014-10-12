###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

class Individual
  constructor: (@chromosome, _fitness)->
    @fitnessFunction = _fitness if _fitness

  fitness: ->
    @_fitnessValue ?= @fitnessFunction @chromosome

  @pair: (selector)->
    new Pair @, selector

  class Pair
    constructor: (@Individual, selector)->
      @parents = [selector.next(), selector.next()]

    crossover: (probability, operator, parents = @parents)->
      @offsprings = if Math.random() < probability
        [c1, c2] = operator.call @,
          parents[0].chromosome.concat(),
          parents[1].chromosome.concat()
        [
          new @Individual c1
          new @Individual c2
        ]
      else
        parents.concat()
      @

    mutate: (probability, operator, targets = @offsprings)->
      for i in [0..targets.length - 1]
        if Math.random() < probability
          targets[i] = new @Individual operator.call @,
            targets[i].chromosome
      @

module.exports = Individual
