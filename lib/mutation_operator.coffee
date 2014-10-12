###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

class MutationOperator
  @binaryInvert: ->
    @replace (gene)-> !gene

  @replace: (alleles)-> (chromosome)->
    locus = Math.floor Math.random() * chromosome.length
    chromosome[locus] = alleles chromosome[locus]
    chromosome

module.exports = MutationOperator
