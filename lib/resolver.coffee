###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

{EventEmitter} = require 'events'

class Resolver extends EventEmitter
  constructor: (reproduct, config = {})->
    if typeof reproduct == 'function'
      config.reproduct = reproduct
    else
      config = reproduct ? {}
    config.reproduct ?= @reproduct
    @config = config

  resolve: (population, config = {}, callback_on_result)->
    if typeof config == 'function'
      callback_on_result = config
      config = {}

    for key of @config
      config[key] ?= @config[key]

    unless typeof config.reproduct == 'function'
      throw new TypeError "#{config.reproduct} is not a function"

    terminates = [].concat config.terminate
      .map (fn)->
        if typeof fn == 'number'
          do (limit = fn)-> (population)->
            population.generationNumber >= limit
        else
          fn
    terminates.unshift => !@processing

    population.sort()
    population.generationNumber = generationNumber = 0
    process = =>
      if @processing
        population = ((config.reproduct.call @, population, config) ? population)
          .sort()
        population.generationNumber = ++generationNumber
        @emit 'reproduct', population, config
      if (terminates.some (fn)-> fn.call @, population)
        @emit 'terminate', population, config
        callback_on_result?.call @, population.best, population, config
      else
        @processing = setTimeout process, config.intervalMillis
    @processing = setTimeout process, config.intervalMillis
    @

  terminate: ->
    @processing = undefined

module.exports = Resolver
