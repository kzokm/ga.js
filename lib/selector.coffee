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

  @roulette: (popuration)->
    S = popuration.fitness.sum()
    new Selector ->
      r = Math.random() * S
      s = 0
      popuration.sample (I)->
        (s += I.fitness) > r

  @tournament: (popuration, size = @tournament.defaultSize)->
    N = popuration.size()
    selector = new Selector ->
      group = for [1..size]
        popuration.get randomInt N
      (group.sort popuration.comparator)[0]
    Object.defineProperty selector, 'size', value: size

  Object.defineProperty @tournament, 'defaultSize', value: 4

module.exports = Selector
