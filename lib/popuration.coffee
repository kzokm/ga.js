###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

require './utils'
{EventEmitter} = require 'events'

class Popuration extends EventEmitter
  constructor: (@Individual, popurationSize = 0) ->
    @generationNumber = 0
    @individuals = if popurationSize > 1
      for [1..popurationSize]
        new Individual
    else
      []

  size: ->
    @individuals.length

  set: (@individuals)->
    @

  add: (individual)->
    @individuals.push individual
    @

  get: (index)->
    index = @individuals.length + index if index < 0
    @individuals[index]

  remove: (individual)->
    if typeof individual == 'number'
      index = individual
      index = @individuals.length + index if index < 0
    else
      index = @individuals.indexOf individual
    (@individuals.splice index, 1)[0] if index >= 0

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
    @individuals.sort @comparator
    @

  @comparator: comparator =
    asc: (i1, i2)-> i1.fitness - i2.fitness
    desc: (i1, i2)-> i2.fitness - i1.fitness

  comparator: comparator.desc

  each: (operator)->
    @individuals.forEach operator, @
    @

  sum: ->
    @individuals.reduce (sum, I)->
      sum += I.fitness
    , 0

  average: ->
    @sum() / @size()

  @property 'best',
    get: -> @individuals[0]

  top: (n)->
    @individuals.slice 0, n

  @property 'worst',
    get: -> @individuals[@individuals.length - 1]

module.exports = Popuration
