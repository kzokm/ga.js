
Math._random ?= Math.random

pesudoRandomValues = []

pesudoRandom = ->
  if Array.isArray pesudoRandomValues
    pesudoRandomValues.shift() ? Math._random()
  else
    pesudoRandomValues

pesudoRandom.MIN_VALUE = 0
pesudoRandom.MAX_VALUE = 0.99999999

pesudoRandom.push = ->
  pesudoRandomValues.push arguments...
  @

pesudoRandom.set = ->
  @clear()
    .push arguments...

pesudoRandom.freeze = (value)->
  pesudoRandomValues = value

pesudoRandom.clear = ->
  pesudoRandomValues = []
  @

pesudoRandom.attach = ->
  afterEach -> pesudoRandom.clear()
  @

module.exports = Math.random = pesudoRandom
