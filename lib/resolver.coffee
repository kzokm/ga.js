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

class Resolver extends EventEmitter
  constructor: (@reproduct, @config = {})->
    unless typeof reproduct == 'function'
      throw new TypeError "#{@reproduct} is not a function"
    @config.terminate ?= []

  resolve: (popuration, config = {}, callback_on_result)->
    if typeof config == 'function'
      callback_on_result = config
      config = {}

    terminates = [].concat config.terminate ?= @config.terminate
      .map (fn)->
        if typeof fn == 'number'
          do (limit = fn)-> (popuration)->
            popuration.generationNumber >= limit
        else
          fn
    terminates.unshift => !@processing
    @processing = true

    popuration.sort()
    setTimeout process = =>
      if @processing
        popuration = (@reproduct.call @, popuration, config) ? popuration
          .sort()
        popuration.generationNumber++
        @emit 'reproduct', popuration, config
      if (terminates.some (fn)-> fn.call @, popuration)
        @emit 'terminate', popuration, config
        callback_on_result?.call @, popuration, config
      else
        setTimeout process
    @
  terminate: ->
    @processing = false

module.exports = Resolver
