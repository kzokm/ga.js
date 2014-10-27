
Math._random ?= Math.random

pesudoRandomValues = []

pesudoRandom = ->
  pesudoRandomValues.shift() ? Math._random()

pesudoRandom.MIN_VALUE = 0
pesudoRandom.MAX_VALUE = 0.99999999

pesudoRandom.push = ->
  pesudoRandomValues.push arguments...
  @

pesudoRandom.set = ->
  @clear()
    .push arguments...

pesudoRandom.clear = ->
  pesudoRandomValues = []
  @

pesudoRandom.attach = ->
  beforeEach -> pesudoRandom.clear()
  @

module.exports = Math.random = pesudoRandom
