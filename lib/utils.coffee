
Function::property ?= (prop, descriptor)->
  Object.defineProperty @prototype, prop, descriptor
  @
