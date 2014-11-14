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

class CrossoverOperator
  randomLocusOf = (c)-> randomInt c.length

  # N point crossover operation
  @point: (n = 1)-> Object.defineProperty(
    if n == 1
      (c1, c2)->
        exchangeAfter c1, c2, randomLocusOf c1
    else if n > 1
      (c1, c2)->
        (randomLocusOf c1 for [1..n])
        .sort (a, b)-> a - b
        .forEach (p, i)->
          p++ if i > 0
          [c1, c2] = exchangeAfter c1, c2, p
        [c1, c2]
    else
      throw new Error "invalid number of crossover point: #{n}"
  , 'n', value: n)

  exchangeAfter = (c1, c2, p)-> [
    c1[...p].concat c2[p...]
    c2[...p].concat c1[p...]
  ]


  # Uniform crossover operation
  @uniform: (probability = 0.5)-> Object.defineProperty (c1, c2)->
    c1 = c1.concat()
    c2 = c2.concat()
    for i in [0..c1.length - 1]
      if Math.random() < probability
        exchange c1, c2, i
    [c1, c2]
  , 'probability', value: probability

  exchange = (c1, c2, pos)->
    temp = c1[pos]; c1[pos] = c2[pos]; c2[pos] = temp


  # Order crossover operation
  @OX: @order = (n = 2)-> Object.defineProperty(
    if 1 <= n <= 2
      (c1, c2)->
        r = randomLocusOf c1 if n == 2
        [c1, c2] = rotate c1, c2, r
        p = randomLocusOf c1
        o1 = order c1, c2, p
        o2 = order c2, c1, p
        rotate o1, o2, -r
    else
      throw new Error "invalid number of crossover point: #{n}"
  , 'n', value: n)

  order = (c1, c2, p)->
    (o = c1[...p]).push (reject c2, o)...
    o

  reject = (array, excepts)->
    array.filter (e)-> (excepts.indexOf e) < 0

  rotate = (c1, c2, p)->
    if p
      c1 = c1[p...].concat c1[...p]
      c2 = c2[p...].concat c2[...p]
    [c1, c2]


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
      break if o1.length == length == countElements(o1)
      p++ while o1[p]
      p = 0 if p == length
      [c1, c2] = [c2, c1]
    [o1, o2]

  countElements = (array)->
    array.reduce ((count)-> count + 1), 0


  # Partially-mapped crossover operation
  @PMX: (n = 2)-> Object.defineProperty(
    if 1 <= n <= 2
      (c1, c2)->
        r = randomLocusOf c1 if n == 2
        [c1, c2] = rotate c1, c2, r
        p = randomLocusOf c1
        o1 = pmx c2, c1, p
        o2 = pmx c1, c2, p
        rotate o1, o2, -r
    else
      throw new Error "invalid number of crossover point: #{n}"
  , 'n', value: n)

  pmx = (c1, c2, p)->
    o = c2[...p]
    for q in [p..c1.length - 1]
      o[q] ?= do ->
        until (o.indexOf g = c1[q]) < 0
          q = c2.indexOf g
        g
    o


module.exports = CrossoverOperator
