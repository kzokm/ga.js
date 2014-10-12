###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

class CrossoverOperator
  @point: (n)-> (c1, c2)->
    for [1..n]
      p = Math.floor Math.random() * c1.length
      [c1, c2] = [
        c1.splice 0, p
          .concat c2.splice p
        c2.concat c1
      ]
    [c1, c2]

  exchange = (c1, c2, pos)->
    temp = c1[pos]; c1[pos] = c2[pos]; c2[pos] = temp

  @uniform: (probability = 0.5)-> (c1, c2)->
    for i in [0..c1.length - 1]
      if Math.random() < probability
        exchange c1, c2, i
    [c1, c2]

module.exports = CrossoverOperator
