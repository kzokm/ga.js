'use strict'
{expect} = require 'chai'

describe 'utils', ->
  utils = require '../lib/utils'

  random = require './lib/pesudo_random'
    .attach()

  describe '.randomInt n', ->
    it 'should return int value', ->
      random.push 0.5
      expect utils.randomInt 3
        .to.equal 1

    it 'should return greater than or equal to 0', ->
      random.push 0
      expect utils.randomInt 0
        .to.equal 0

    it 'should return less than n', ->
      random.push random.MAX_VALUE
      expect utils.randomInt 10
        .to.equal 9


  describe '.contains array element', ->
    it 'should return true if an array contains a element', ->
      expect utils.contains [1, 2, 3], 2
        .to.be.true

    it 'should return false if an array not contain a element', ->
      expect utils.contains [1, 2, 3], 4
        .to.be.false


  describe '.count array', ->
    it 'should return number of element in array', ->
      array = []
      array[1] = null
      array[3] = undefined
      array[5] = false
      expect array.length
        .to.equal 6
      expect utils.count array
        .to.equal 3

    it 'should not count undefied elements', ->
      array = [1, 2, 3, 4, 5]
      delete array[1]
      delete array[4]
      expect array.length
        .to.equal 5
      expect utils.count array
        .to.equal 3


  describe '.rotate array, count', ->
    array = [1, 2, 3, 4, 5]

    it 'should return left rotated array', ->
      expect utils.rotate array, 2
        .to.deep.equal [3, 4, 5, 1, 2]

    it 'should return right rotated array if count is negative', ->
      expect utils.rotate array, -1
        .to.deep.equal [5, 1, 2, 3, 4]


  describe '.reject array, excepts', ->
    it 'should return new array not contains element of excepts', ->
      array = [1, 2, 3, 2, 4, 3, 1, 5]

      expect utils.reject array, [1]
        .to.deep.equal [2, 3, 2, 4, 3, 5]

      expect utils.reject array, [2, 3]
        .to.deep.equal [1, 4, 1, 5]
