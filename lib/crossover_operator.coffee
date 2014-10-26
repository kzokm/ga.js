###
# Genetic Algorithm API for JavaScript
# https://github.com/techlier/ga.js.git/
#
# Copyright (c) 2014 Techlier Inc.
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php
###

CrossoverOperator =
  point: (n)->
    if n == 1
      (c1, c2)->
        _exchangeAfter c1, c2, _randomLocusOf c1
    else
      (c1, c2)->
        locus = for [1..n]
          _randomLocusOf c1
        locus.sort (a, b)-> a - b
          .forEach (p, i)->
            p++ if i > 0
            [c1, c2] = _exchangeAfter c1, c2, p
        [c1, c2]

  uniform: (probability = 0.5)-> (c1, c2)->
    c1 = c1.concat()
    c2 = c2.concat()
    for i in [0..c1.length - 1]
      if Math.random() < probability
        _exchange c1, c2, i
    [c1, c2]


_randomLocusOf = (c)->
   Math.floor Math.random() * c.length

_exchangeAfter = (c1, c2, p)->
   [
     c1.slice 0, p
       .concat c2.slice p
     c2.slice 0, p
       .concat c1.slice p
   ]

_exchange = (c1, c2, pos)->
  temp = c1[pos]; c1[pos] = c2[pos]; c2[pos] = temp


module.exports = CrossoverOperator
