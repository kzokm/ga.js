###
# Genetic Algorithm API for JavaScript
# https://github.com/kzokm/ga.js
#
# Copyright (c) 2014 OKAMURA, Kazuhide
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

utils = require './utils'

class CrossoverOperator
  randomLocusOf = (c)-> utils.randomInt c.length

  # N point crossover operation
  @point: (n = 1)-> Object.defineProperty(
    if n == 1
      (c1, c2)->
        swapAfter c1, c2, randomLocusOf c1
    else if n > 1
      (c1, c2)->
        (randomLocusOf c1 for [1..n])
        .sort (a, b)-> a - b
        .forEach (p, i)->
          p++ if i > 0
          [c1, c2] = swapAfter c1, c2, p
        [c1, c2]
    else
      throw new Error "invalid number of crossover point: #{n}"
  , 'n', value: n)

  swapAfter = (c1, c2, p)-> [
    c1[...p].concat c2[p...]
    c2[...p].concat c1[p...]
  ]


  # Uniform crossover operation
  @uniform: (probability = 0.5)-> Object.defineProperty (c1, c2)->
    c1 = c1.concat()
    c2 = c2.concat()
    for i in [0..c1.length - 1]
      if Math.random() < probability
        swap c1, c2, i
    [c1, c2]
  , 'probability', value: probability

  swap = (array1, array2, p)->
    temp = array1[p]
    array1[p] = array2[p]
    array2[p] = temp
    undefined


  # Order crossover operation
  @OX: @order = (n)-> withRotation n, (c1, c2, p)->
    (o = c1[...p]).push (utils.reject c2, o)...
    o


  withRotation = (n = 2, operator)-> Object.defineProperty(
    if 1 <= n <= 2
      (c1, c2)->
        if n == 2 and r = randomLocusOf c1
          c1 = utils.rotate c1, r
          c2 = utils.rotate c2, r
        p = randomLocusOf c1
        o1 = operator c1, c2, p
        o2 = operator c2, c1, p
        if r
          o1 = utils.rotate o1, -r
          o2 = utils.rotate o2, -r
        [o1, o2]
    else
      throw new Error "invalid number of crossover point: #{n}"
  , 'n', value: n)


  # Cycle crossover operation
  @CX: @cycle = -> (c1, c2)->
    length = c1.length
    o1 = []
    o2 = []
    p = randomLocusOf c1
    loop
      until o1[p]?
        o1[p] = c1[p]
        o2[p] = c2[p]
        p = c1.indexOf c2[p]
        throw new Error 'Invalid chromosome for cyclic crossover' if p < 0
      break if o1.length == length == utils.count o1
      p++ while o1[p]
      p = 0 if p == length
      [c1, c2] = [c2, c1]
    [o1, o2]


  # Partially-mapped crossover operation
  @PMX: @partiallyMapped = (n)-> withRotation n, (c1, c2, p)->
    o = c1[...p]
    for q in [p..c1.length - 1]
      o[q] ?= do ->
        while utils.contains o, (g = c2[q])
          q = c1.indexOf g
        g
    o


module.exports = CrossoverOperator
