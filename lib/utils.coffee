
Function::property ?= (prop, descriptor)->
  Object.defineProperty @prototype, prop, descriptor
  @

module.exports =
  randomInt: (n)->
    Math.floor Math.random() * n
