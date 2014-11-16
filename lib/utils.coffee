
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

  swap: (array, pos1, pos2)->
    if pos1 != pos2
      temp = array[pos1]
      array[pos1] = array[pos2]
      array[pos2] = temp
    array

  scramble: (array, offset = 0, length = array.length - offset)->
    while length
      r = utils.randomInt length--
      utils.swap array, offset, offset + r
      offset++
    array

module.exports = utils
