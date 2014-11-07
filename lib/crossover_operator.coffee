###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

class CrossoverOperator
  randomLocusOf = (c)->
    Math.floor Math.random() * c.length

  @point: (n)->
    if n == 1
      (c1, c2)->
        exchangeAfter c1, c2, randomLocusOf c1
    else
      (c1, c2)->
        locus = for [1..n]
          randomLocusOf c1
        locus.sort (a, b)-> a - b
          .forEach (p, i)->
            p++ if i > 0
            [c1, c2] = exchangeAfter c1, c2, p
        [c1, c2]

  exchangeAfter = (c1, c2, p)-> [
    c1[...p].concat c2[p...]
    c2[...p].concat c1[p...]
  ]


  @uniform: (probability = 0.5)-> (c1, c2)->
    c1 = c1.concat()
    c2 = c2.concat()
    for i in [0..c1.length - 1]
      if Math.random() < probability
        exchange c1, c2, i
    [c1, c2]

  exchange = (c1, c2, pos)->
    temp = c1[pos]; c1[pos] = c2[pos]; c2[pos] = temp


  @OX: @order = -> (c1, c2)->
    p = randomLocusOf c1
    (o1 = c1[...p]).push (reject c2, o1)...
    (o2 = c2[...p]).push (reject c1, o2)...
    [o1, o2]

  reject = (array, excepts)->
    array.filter (e)-> (excepts.indexOf e) < 0

  @CS: @cycle = -> (c1, c2)->

module.exports = CrossoverOperator
