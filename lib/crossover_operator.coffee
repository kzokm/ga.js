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

  # N point crossover operation
  @point: (n)->
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
      throw new Error 'invalid number of crossover point: #{n}'

  exchangeAfter = (c1, c2, p)-> [
    c1[...p].concat c2[p...]
    c2[...p].concat c1[p...]
  ]


  # Uniform crossover operation
  @uniform: (probability = 0.5)-> (c1, c2)->
    c1 = c1.concat()
    c2 = c2.concat()
    for i in [0..c1.length - 1]
      if Math.random() < probability
        exchange c1, c2, i
    [c1, c2]

  exchange = (c1, c2, pos)->
    temp = c1[pos]; c1[pos] = c2[pos]; c2[pos] = temp


  # Order crossover operation
  @OX: @order = -> (c1, c2)->
    p = randomLocusOf c1
    (o1 = c1[...p]).push (reject c2, o1)...
    (o2 = c2[...p]).push (reject c1, o2)...
    [o1, o2]

  reject = (array, excepts)->
    array.filter (e)-> (excepts.indexOf e) < 0


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
      p %= length
      [c1, c2] = [c2, c1]
    [o1, o2]

  countElements = (array)->
    array.reduce ((count)-> count + 1), 0


  # Partially-mapped crossover operation
  @PMX: (n = 2)->
    if n == 1
      (c1, c2)->
        p = randomLocusOf c1
        o1 = pmx c1[...p], c2, c1
        o2 = pmx c2[...p], c1, c2
        [o1, o2]
    else if n == 2
      (c1, c2)->
        p = randomLocusOf c1
        q = randomLocusOf c1
        if p > q
          [p, q] = [q, p]
        o1 = []
        o2 = []
        for i in [p..q - 1]
          o1[i]= c1[i]
          o2[i]= c2[i]
        o1 = pmx o1, c2, c1
        o2 = pmx o2, c1, c2
        [o1, o2]
    else
      throw new Error 'invalid number of crossover point: #{n}'

  pmx = (o, c1, c2)->
    for p in [0..c1.length - 1]
      o[p] ?= do ->
        until (o.indexOf c1[p]) < 0
          p = c2.indexOf c1[p]
        c1[p]

module.exports = CrossoverOperator
