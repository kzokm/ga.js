###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

{EventEmitter} = require 'events'

class Popuration extends EventEmitter
  constructor: (@Individual, @popurationSize) ->
    @generationNumber = 1
    @individuals = for [1..popurationSize]
      new Individual

  size: ->
    @individuals.length

  set: (@individuals)->
    @

  add: (individual)->
    @individuals.push individual
    @

  remove: (individual)->
    index =
      if typeof individual == 'number'
        individual
      else
        @individuals.indexOf individual
    (@individuals.splice index, 0)[0] if index >= 0

  get: (index)->
    @individuals[index]

  sample: (sampler)->
    switch typeof sampler
      when 'undefined'
        @get Math.floor Math.random() * @individuals.length
      when 'number'
        @get sampler
      when 'function'
        selected = undefined
        @individuals.some (I)->
          selected = I if sampler I
        selected

  sort: ->
    @individuals.sort (i1, i2)->
      i2.fitness() - i1.fitness()
    @

  each: (operator)->
    @individuals.forEach operator, @
    @

  some: (operator)->
    @individuals.some operator, @
    @

  sum: ->
    @individuals.reduce (sum, I)->
      sum += I.fitness()
    , 0

  average: ->
    @sum() / @size()

  best: (n)->
    @individuals[0]

  top: (n)->
    @individuals.slice 0, n

  worst: (n)->
    @individuals[@individuals.length - 1]

module.exports = Popuration
