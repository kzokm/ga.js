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

  resolve: (popuration, config = {}, callback_on_result)->
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
          do (limit = fn)-> (popuration)->
            popuration.generationNumber >= limit
        else
          fn
    terminates.unshift => !@processing

    popuration.sort()
    popuration.generationNumber = generationNumber = 0
    process = =>
      if @processing
        popuration = ((config.reproduct.call @, popuration, config) ? popuration)
          .sort()
        popuration.generationNumber = ++generationNumber
        @emit 'reproduct', popuration, config
      if (terminates.some (fn)-> fn.call @, popuration)
        @emit 'terminate', popuration, config
        callback_on_result?.call @, popuration.best(), popuration, config
      else
        @processing = setTimeout process, config.intervalMillis
    @processing = setTimeout process, config.intervalMillis
    @

  terminate: ->
    @processing = undefined

module.exports = Resolver
