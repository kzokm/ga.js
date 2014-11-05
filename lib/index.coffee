###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

'use strict'

class GA
  @version: require './version'
  @Resolver: require './resolver'
  @Popuration: require './popuration'
  @Individual: require './individual'
  @Selector: require './selector'
  @Crossover: require './crossover_operator'
  @Mutation: require './mutation_operator'

module.exports = GA
