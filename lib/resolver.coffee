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
  resolve: (popuration, config, callback)->
    if typeof config == 'function'
      callback = config
      config = {}

    reproduct = config.reproduct

    terminates = [].concat config.terminate ? []
      .map (fn)->
        if typeof fn == 'number'
          do (limit = fn)-> (popuration)->
            popuration.generationNumber >= limit
        else
          fn

    popuration.sort()
    setTimeout process = do (resolver = @)-> ->
      popuration = reproduct.call resolver, popuration
        .sort()
      popuration.generationNumber++

      resolver.emit 'reproduct', popuration
      if (terminates.some (fn)-> fn.call resolver, popuration)
        resolver.emit 'terminate', popuration, popuration.best()
        callback?.call resolver, popuration.best()
      else
        setTimeout process
    @

module.exports = Resolver
