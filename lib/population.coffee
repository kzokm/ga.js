###
# Genetic Algorithm API for JavaScript
# https://github.com/kzokm/ga.js
#
# Copyright (c) 2014 OKAMURA, Kazuhide
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

{randomInt} = require './utils'
{EventEmitter} = require 'events'

class Population extends EventEmitter
  constructor: (@Individual, populationSize = 0) ->
    @generationNumber = 0
    @individuals = if populationSize > 1
      for [1..populationSize]
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
        @get randomInt @individuals.length
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

  @property 'fitness',
    get: -> @_fitness ?=
      sum: =>
        @individuals.reduce (sum, I)->
          sum += I.fitness
        , 0
      average: =>
        @fitness.sum() / @size()

  @property 'best',
    get: -> @individuals[0]

  top: (n)->
    @individuals.slice 0, n

  @property 'worst',
    get: -> @individuals[@individuals.length - 1]

module.exports = Population
