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

  describe '.swap array, pos1, pos2', ->
    array = [1, 2, 3, 4, 5]

    it 'should return array it self, that exchaged element at pos1 and pos2', ->
      expect utils.swap array, 0, 4
        .to.equal array
        .and.deep.equal [5, 2, 3, 4, 1]

      expect utils.swap array, 1, 3
        .to.deep.equal [5, 4, 3, 2, 1]

  describe '.reject array, excepts', ->
    it 'should return new array not contains element of excepts', ->
      array = [1, 2, 3, 2, 4, 3, 1, 5]

      expect utils.reject array, [1]
        .to.deep.equal [2, 3, 2, 4, 3, 5]

      expect utils.reject array, [2, 3]
        .to.deep.equal [1, 4, 1, 5]

  describe '.scramble array, offset, length', ->
    array = [1, 2, 3, 4, 5]

    it 'should return array it self,', ->
      random.freeze 0
      expect utils.scramble array
        .to.equal array
        .and.deep.equal [1, 2, 3, 4, 5]

    it 'can scramble array,', ->
      random.freeze random.MAX_VALUE
      expect utils.scramble array
        .to.equal array
        .and.deep.equal [5, 1, 2, 3, 4]

      expect utils.scramble array, 1
        .to.equal array
        .and.deep.equal [5, 4, 1, 2, 3]

      expect utils.scramble array, 1, 3
        .to.equal array
        .and.deep.equal [5, 2, 4, 1, 3]
