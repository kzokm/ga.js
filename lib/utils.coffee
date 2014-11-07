
Function::property = (prop, descriptor)->
  Object.defineProperty @prototype, prop, descriptor
  @

Object::defineProperty = (prop, descriptor)->
  Object.defineProperty @, prop, descriptor
