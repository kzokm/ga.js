
Function::property ?= (prop, descriptor)->
  Object.defineProperty @prototype, prop, descriptor
  @

utils =
  # Math
  randomInt: (n)->
    Math.floor Math.random() * n

  # Arrays
  count: (array)->
    array.reduce ((count)-> count + 1), 0

  contains: (array, element)->
    (array.indexOf element) >= 0

  rotate: (array, count)->
    array[count...].concat array[...count]

  reject: (array, excepts)->
    array.filter (e)-> !utils.contains excepts, e

module.exports = utils
