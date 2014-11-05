###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

class Selector
  constructor: (@next)->

  @roulette: (popuration)->
    S = popuration.sum()
    new Selector ->
      r = Math.random() * S
      s = 0
      popuration.sample (I)->
        (s += I.fitness()) > r

module.exports = Selector
