###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

MutationOperator =
  booleanInversion: ->
    @substitution (gene)-> !gene

  binaryInversion: ->
    @substitution (gene)-> 1 - gene

  substitution: (alleles)-> (chromosome)->
    p = _randomLocusOf chromosome
    chromosome[p] = alleles chromosome[p]
    chromosome

  exchange: -> (chromosome)->
    p1 = _randomLocusOf chromosome
    p2 = _randomLocusOf chromosome
    _exchange chromosome, p1, p2
    chromosome

  reverse: -> (chromosome)->
    p1 = _randomLocusOf chromosome
    p2 = _randomLocusOf chromosome

    c1 = chromosome.splice 0, Math.min p1, p2
    c2 = chromosome.splice 0, (Math.abs p1 - p2) + 1
    c3 = chromosome

    c1.concat c2.reverse(), c3


_randomLocusOf = (chromosome)->
   Math.floor Math.random() * chromosome.length

_exchange = (c, p1, p2)->
  temp = c[p1]; c[p1] = c[p2]; c[p2] = temp


module.exports = MutationOperator
