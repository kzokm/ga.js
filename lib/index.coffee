###
# Genetic Algorithm API for JavaScript
# https://github.com/kzokm/ga.js
#
# Copyright (c) 2014 OKAMURA, Kazuhide
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

'use strict'

class GA
  @version: require './version'
  @Resolver: require './resolver'
  @Population: require './population'
  @Individual: require './individual'
  @Selector: require './selector'
  @Crossover: require './crossover_operator'
  @Mutation: require './mutation_operator'

  for prop, value of require './utils'
    @[prop] ?= value

module.exports = GA
