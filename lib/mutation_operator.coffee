###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

deprecated = require 'deprecated'

class MutationOperator
  randomLocusOf = (chromosome)->
    Math.floor Math.random() * chromosome.length

  @booleanInversion: ->
    @substitution (gene)-> !gene

  @binaryInversion: ->
    @substitution (gene)-> 1 - gene

  @substitution: (alleles)-> (chromosome)->
    p = randomLocusOf chromosome
    chromosome[p] = alleles chromosome[p]
    chromosome


  @exchange: -> (chromosome)->
    p1 = randomLocusOf chromosome
    p2 = randomLocusOf chromosome
    exchange chromosome, p1, p2
    chromosome

  exchange = (c, p1, p2)->
    temp = c[p1]; c[p1] = c[p2]; c[p2] = temp


  @inversion: -> (chromosome)->
    p1 = randomLocusOf chromosome
    p2 = randomLocusOf chromosome

    c1 = chromosome.splice 0, Math.min p1, p2
    c2 = chromosome.splice 0, (Math.abs p1 - p2) + 1
    c3 = chromosome

    c1.concat c2.reverse(), c3

  @reverse: deprecated.method 'Mutation.reverse is deprecated, Use inversion instead',
    console.log, @inversion


module.exports = MutationOperator
