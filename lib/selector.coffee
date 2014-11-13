###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

{randomInt} = require './utils'

class Selector
  constructor: (@next)->

  @roulette: (population)->
    S = population.fitness.sum()
    new Selector ->
      r = Math.random() * S
      s = 0
      population.sample (I)->
        (s += I.fitness) > r

  @tournament: (population, size = @tournament.defaultSize)->
    N = population.size()
    selector = new Selector ->
      group = for [1..size]
        population.get randomInt N
      (group.sort population.comparator)[0]
    Object.defineProperty selector, 'size', value: size

  Object.defineProperty @tournament, 'defaultSize', value: 4

module.exports = Selector
