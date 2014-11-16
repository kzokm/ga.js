(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
window.GA = require('../lib/index');



},{"../lib/index":3}],2:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var CrossoverOperator, utils;

utils = require('./utils');

CrossoverOperator = (function() {
  var randomLocusOf, swap, swapAfter, withRotation;

  function CrossoverOperator() {}

  randomLocusOf = function(c) {
    return utils.randomInt(c.length);
  };

  CrossoverOperator.point = function(n) {
    if (n == null) {
      n = 1;
    }
    return Object.defineProperty((function() {
      if (n === 1) {
        return function(c1, c2) {
          return swapAfter(c1, c2, randomLocusOf(c1));
        };
      } else if (n > 1) {
        return function(c1, c2) {
          ((function() {
            var _i, _results;
            _results = [];
            for (_i = 1; 1 <= n ? _i <= n : _i >= n; 1 <= n ? _i++ : _i--) {
              _results.push(randomLocusOf(c1));
            }
            return _results;
          })()).sort(function(a, b) {
            return a - b;
          }).forEach(function(p, i) {
            var _ref;
            if (i > 0) {
              p++;
            }
            return _ref = swapAfter(c1, c2, p), c1 = _ref[0], c2 = _ref[1], _ref;
          });
          return [c1, c2];
        };
      } else {
        throw new Error("invalid number of crossover point: " + n);
      }
    })(), 'n', {
      value: n
    });
  };

  swapAfter = function(c1, c2, p) {
    return [c1.slice(0, p).concat(c2.slice(p)), c2.slice(0, p).concat(c1.slice(p))];
  };

  CrossoverOperator.uniform = function(probability) {
    if (probability == null) {
      probability = 0.5;
    }
    return Object.defineProperty(function(c1, c2) {
      var i, _i, _ref;
      c1 = c1.concat();
      c2 = c2.concat();
      for (i = _i = 0, _ref = c1.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (Math.random() < probability) {
          swap(c1, c2, i);
        }
      }
      return [c1, c2];
    }, 'probability', {
      value: probability
    });
  };

  swap = function(array1, array2, p) {
    var temp;
    temp = array1[p];
    array1[p] = array2[p];
    array2[p] = temp;
    return void 0;
  };

  CrossoverOperator.OX = CrossoverOperator.order = function(n) {
    return withRotation(n, function(c1, c2, p) {
      var o, _ref;
      (_ref = (o = c1.slice(0, p))).push.apply(_ref, utils.reject(c2, o));
      return o;
    });
  };

  withRotation = function(n, operator) {
    if (n == null) {
      n = 2;
    }
    return Object.defineProperty((function() {
      if ((1 <= n && n <= 2)) {
        return function(c1, c2) {
          var o1, o2, p, r;
          if (n === 2 && (r = randomLocusOf(c1))) {
            c1 = utils.rotate(c1, r);
            c2 = utils.rotate(c2, r);
          }
          p = randomLocusOf(c1);
          o1 = operator(c1, c2, p);
          o2 = operator(c2, c1, p);
          if (r) {
            o1 = utils.rotate(o1, -r);
            o2 = utils.rotate(o2, -r);
          }
          return [o1, o2];
        };
      } else {
        throw new Error("invalid number of crossover point: " + n);
      }
    })(), 'n', {
      value: n
    });
  };

  CrossoverOperator.CX = CrossoverOperator.cycle = function() {
    return function(c1, c2) {
      var length, o1, o2, p, _ref;
      length = c1.length;
      o1 = [];
      o2 = [];
      p = randomLocusOf(c1);
      while (true) {
        while (o1[p] == null) {
          o1[p] = c1[p];
          o2[p] = c2[p];
          p = c1.indexOf(c2[p]);
          if (p < 0) {
            throw new Error('Invalid chromosome for cyclic crossover');
          }
        }
        if ((o1.length === length && length === utils.count(o1))) {
          break;
        }
        while (o1[p]) {
          p++;
        }
        if (p === length) {
          p = 0;
        }
        _ref = [c2, c1], c1 = _ref[0], c2 = _ref[1];
      }
      return [o1, o2];
    };
  };

  CrossoverOperator.PMX = CrossoverOperator.partiallyMapped = function(n) {
    return withRotation(n, function(c1, c2, p) {
      var o, q, _i, _ref;
      o = c1.slice(0, p);
      for (q = _i = p, _ref = c1.length - 1; p <= _ref ? _i <= _ref : _i >= _ref; q = p <= _ref ? ++_i : --_i) {
        if (o[q] == null) {
          o[q] = (function() {
            var g;
            while (utils.contains(o, (g = c2[q]))) {
              q = c1.indexOf(g);
            }
            return g;
          })();
        }
      }
      return o;
    });
  };

  return CrossoverOperator;

})();

module.exports = CrossoverOperator;



},{"./utils":9}],3:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
'use strict';
var GA;

GA = (function() {
  var prop, value, _ref;

  function GA() {}

  GA.version = require('./version');

  GA.Resolver = require('./resolver');

  GA.Population = require('./population');

  GA.Individual = require('./individual');

  GA.Selector = require('./selector');

  GA.Crossover = require('./crossover_operator');

  GA.Mutation = require('./mutation_operator');

  _ref = require('./utils');
  for (prop in _ref) {
    value = _ref[prop];
    if (GA[prop] == null) {
      GA[prop] = value;
    }
  }

  return GA;

})();

module.exports = GA;



},{"./crossover_operator":2,"./individual":4,"./mutation_operator":5,"./population":6,"./resolver":7,"./selector":8,"./utils":9,"./version":10}],4:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var Individual;

require('./utils');

Individual = (function() {
  function Individual(chromosome, fitnessFunction) {
    this.chromosome = chromosome;
    if (fitnessFunction != null) {
      this.fitnessFunction = fitnessFunction;
    }
  }

  Individual.property('fitness', {
    get: function() {
      return this._fitnessValue != null ? this._fitnessValue : this._fitnessValue = this.fitnessFunction(this.chromosome);
    }
  });

  Individual.prototype.mutate = function(operator) {
    if (typeof operator !== 'function') {
      throw TypeError("Mutation operator is not function: " + operator);
    }
    this.chromosome = operator(this.chromosome);
    this._fitnessValue = void 0;
    return this;
  };

  Individual.pair = function(selector) {
    return new this.Pair(this, selector);
  };

  Individual.Pair = (function() {
    function _Class(Individual, selector) {
      this.Individual = Individual;
      this.parents = [selector.next(), selector.next()];
    }

    _Class.prototype.crossover = function(probability, operator, parents) {
      if (parents == null) {
        parents = this.parents;
      }
      if (typeof operator !== 'function') {
        throw TypeError("Crossover operator is not function: " + operator);
      }
      this.offsprings = Math.random() < probability ? operator.apply(this, parents.map(function(i) {
        return i.chromosome;
      })).map((function(_this) {
        return function(c) {
          return new _this.Individual(c);
        };
      })(this)) : parents.map((function(_this) {
        return function(i) {
          return new _this.Individual(i.chromosome.slice(0));
        };
      })(this));
      return this;
    };

    _Class.prototype.mutate = function(probability, operator, targets) {
      if (targets == null) {
        targets = this.offsprings;
      }
      if (typeof operator !== 'function') {
        throw TypeError("Mutation operator is not function: " + operator);
      }
      targets.forEach(function(i) {
        if (Math.random() < probability) {
          return i.mutate(operator);
        }
      });
      return this;
    };

    return _Class;

  })();

  return Individual;

})();

module.exports = Individual;



},{"./utils":9}],5:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var MutationOperator, deprecated, randomInt;

randomInt = require('./utils').randomInt;

deprecated = require('deprecated');

MutationOperator = (function() {
  var randomLocusOf, swap;

  function MutationOperator() {}

  randomLocusOf = function(c) {
    return randomInt(c.length);
  };

  MutationOperator.booleanInversion = function() {
    return this.substitution(function(gene) {
      return !gene;
    });
  };

  MutationOperator.binaryInversion = function() {
    return this.substitution(function(gene) {
      return 1 - gene;
    });
  };

  MutationOperator.substitution = function(alleles) {
    return function(chromosome) {
      var p;
      p = randomLocusOf(chromosome);
      chromosome[p] = alleles(chromosome[p]);
      return chromosome;
    };
  };

  MutationOperator.swap = function() {
    return function(chromosome) {
      var p1, p2;
      p1 = randomLocusOf(chromosome);
      p2 = randomLocusOf(chromosome);
      swap(chromosome, p1, p2);
      return chromosome;
    };
  };

  swap = function(c, p1, p2) {
    var temp;
    temp = c[p1];
    c[p1] = c[p2];
    return c[p2] = temp;
  };

  MutationOperator.inversion = function() {
    return function(chromosome) {
      var c1, c2, c3, p1, p2;
      p1 = randomLocusOf(chromosome);
      p2 = randomLocusOf(chromosome);
      c1 = chromosome.splice(0, Math.min(p1, p2));
      c2 = chromosome.splice(0, (Math.abs(p1 - p2)) + 1);
      c3 = chromosome;
      return c1.concat(c2.reverse(), c3);
    };
  };

  MutationOperator.reverse = deprecated.method('Mutation.reverse is deprecated, Use inversion instead', console.log, MutationOperator.inversion);

  return MutationOperator;

})();

module.exports = MutationOperator;



},{"./utils":9,"deprecated":12}],6:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var EventEmitter, Population, randomInt,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

randomInt = require('./utils').randomInt;

EventEmitter = require('events').EventEmitter;

Population = (function(_super) {
  var comparator;

  __extends(Population, _super);

  function Population(Individual, populationSize) {
    this.Individual = Individual;
    if (populationSize == null) {
      populationSize = 0;
    }
    this.generationNumber = 0;
    this.individuals = (function() {
      var _i, _results;
      if (populationSize > 1) {
        _results = [];
        for (_i = 1; 1 <= populationSize ? _i <= populationSize : _i >= populationSize; 1 <= populationSize ? _i++ : _i--) {
          _results.push(new Individual);
        }
        return _results;
      } else {
        return [];
      }
    })();
  }

  Population.prototype.size = function() {
    return this.individuals.length;
  };

  Population.prototype.set = function(individuals) {
    this.individuals = individuals;
    return this;
  };

  Population.prototype.add = function(individual) {
    this.individuals.push(individual);
    return this;
  };

  Population.prototype.get = function(index) {
    if (index < 0) {
      index = this.individuals.length + index;
    }
    return this.individuals[index];
  };

  Population.prototype.remove = function(individual) {
    var index;
    if (typeof individual === 'number') {
      index = individual;
      if (index < 0) {
        index = this.individuals.length + index;
      }
    } else {
      index = this.individuals.indexOf(individual);
    }
    if (index >= 0) {
      return (this.individuals.splice(index, 1))[0];
    }
  };

  Population.prototype.sample = function(sampler) {
    var selected;
    switch (typeof sampler) {
      case 'undefined':
        return this.get(randomInt(this.individuals.length));
      case 'number':
        return this.get(sampler);
      case 'function':
        selected = void 0;
        this.individuals.some(function(I) {
          if (sampler(I)) {
            return selected = I;
          }
        });
        return selected;
    }
  };

  Population.prototype.sort = function() {
    this.individuals.sort(this.comparator);
    return this;
  };

  Population.comparator = comparator = {
    asc: function(i1, i2) {
      return i1.fitness - i2.fitness;
    },
    desc: function(i1, i2) {
      return i2.fitness - i1.fitness;
    }
  };

  Population.prototype.comparator = comparator.desc;

  Population.prototype.each = function(operator) {
    this.individuals.forEach(operator, this);
    return this;
  };

  Population.property('fitness', {
    get: function() {
      return this._fitness != null ? this._fitness : this._fitness = {
        sum: (function(_this) {
          return function() {
            return _this.individuals.reduce(function(sum, I) {
              return sum += I.fitness;
            }, 0);
          };
        })(this),
        average: (function(_this) {
          return function() {
            return _this.fitness.sum() / _this.size();
          };
        })(this)
      };
    }
  });

  Population.property('best', {
    get: function() {
      return this.individuals[0];
    }
  });

  Population.prototype.top = function(n) {
    return this.individuals.slice(0, n);
  };

  Population.property('worst', {
    get: function() {
      return this.individuals[this.individuals.length - 1];
    }
  });

  return Population;

})(EventEmitter);

module.exports = Population;



},{"./utils":9,"events":11}],7:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var EventEmitter, Resolver,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

EventEmitter = require('events').EventEmitter;

Resolver = (function(_super) {
  __extends(Resolver, _super);

  function Resolver(reproduct, config) {
    if (config == null) {
      config = {};
    }
    if (typeof reproduct === 'function') {
      config.reproduct = reproduct;
    } else {
      config = reproduct != null ? reproduct : {};
    }
    if (config.reproduct == null) {
      config.reproduct = this.reproduct;
    }
    this.config = config;
  }

  Resolver.prototype.resolve = function(population, config, callback_on_result) {
    var generationNumber, key, process, terminates;
    if (config == null) {
      config = {};
    }
    if (typeof config === 'function') {
      callback_on_result = config;
      config = {};
    }
    for (key in this.config) {
      if (config[key] == null) {
        config[key] = this.config[key];
      }
    }
    if (typeof config.reproduct !== 'function') {
      throw new TypeError("" + config.reproduct + " is not a function");
    }
    terminates = [].concat(config.terminate).map(function(fn) {
      if (typeof fn === 'number') {
        return (function(limit) {
          return function(population) {
            return population.generationNumber >= limit;
          };
        })(fn);
      } else {
        return fn;
      }
    });
    terminates.unshift((function(_this) {
      return function() {
        return !_this.processing;
      };
    })(this));
    population.sort();
    population.generationNumber = generationNumber = 0;
    process = (function(_this) {
      return function() {
        var _ref;
        if (_this.processing) {
          population = ((_ref = config.reproduct.call(_this, population, config)) != null ? _ref : population).sort();
          population.generationNumber = ++generationNumber;
          _this.emit('reproduct', population, config);
        }
        if (terminates.some(function(fn) {
          return fn.call(this, population);
        })) {
          _this.emit('terminate', population, config);
          return callback_on_result != null ? callback_on_result.call(_this, population.best, population, config) : void 0;
        } else {
          return _this.processing = setTimeout(process, config.intervalMillis);
        }
      };
    })(this);
    this.processing = setTimeout(process, config.intervalMillis);
    return this;
  };

  Resolver.prototype.terminate = function() {
    return this.processing = void 0;
  };

  return Resolver;

})(EventEmitter);

module.exports = Resolver;



},{"events":11}],8:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
var Selector, randomInt;

randomInt = require('./utils').randomInt;

Selector = (function() {
  function Selector(next) {
    this.next = next;
  }

  Selector.roulette = function(population) {
    var S;
    S = population.fitness.sum();
    return new Selector(function() {
      var r, s;
      r = Math.random() * S;
      s = 0;
      return population.sample(function(I) {
        return (s += I.fitness) > r;
      });
    });
  };

  Selector.tournament = function(population, size) {
    var N, selector;
    if (size == null) {
      size = this.tournament.defaultSize;
    }
    N = population.size();
    selector = new Selector(function() {
      var group;
      group = (function() {
        var _i, _results;
        _results = [];
        for (_i = 1; 1 <= size ? _i <= size : _i >= size; 1 <= size ? _i++ : _i--) {
          _results.push(population.get(randomInt(N)));
        }
        return _results;
      })();
      return (group.sort(population.comparator))[0];
    });
    return Object.defineProperty(selector, 'size', {
      value: size
    });
  };

  Object.defineProperty(Selector.tournament, 'defaultSize', {
    value: 4
  });

  return Selector;

})();

module.exports = Selector;



},{"./utils":9}],9:[function(require,module,exports){
var utils, _base;

if ((_base = Function.prototype).property == null) {
  _base.property = function(prop, descriptor) {
    Object.defineProperty(this.prototype, prop, descriptor);
    return this;
  };
}

utils = {
  randomInt: function(n) {
    return Math.floor(Math.random() * n);
  },
  count: function(array) {
    return array.reduce((function(count) {
      return count + 1;
    }), 0);
  },
  contains: function(array, element) {
    return (array.indexOf(element)) >= 0;
  },
  rotate: function(array, count) {
    return array.slice(count).concat(array.slice(0, count));
  },
  reject: function(array, excepts) {
    return array.filter(function(e) {
      return !utils.contains(excepts, e);
    });
  },
  swap: function(array, pos1, pos2) {
    var temp;
    if (pos1 !== pos2) {
      temp = array[pos1];
      array[pos1] = array[pos2];
      array[pos2] = temp;
    }
    return array;
  },
  scramble: function(array, offset, length) {
    var r;
    if (offset == null) {
      offset = 0;
    }
    if (length == null) {
      length = array.length - offset;
    }
    while (length) {
      r = utils.randomInt(length--);
      utils.swap(array, offset, offset + r);
      offset++;
    }
    return array;
  }
};

module.exports = utils;



},{}],10:[function(require,module,exports){

/*
 * Genetic Algorithm API for JavaScript
 * https://github.com/kzokm/ga.js
 *
 * Copyright (c) 2014 OKAMURA, Kazuhide
 *
 * This software is released under the MIT License.
 * http://opensource.org/licenses/mit-license.php
 */
module.exports = {
  full: '0.5.0-SNAPSHOT',
  major: 0,
  minor: 5,
  dot: 0
};



},{}],11:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

function EventEmitter() {
  this._events = this._events || {};
  this._maxListeners = this._maxListeners || undefined;
}
module.exports = EventEmitter;

// Backwards-compat with node 0.10.x
EventEmitter.EventEmitter = EventEmitter;

EventEmitter.prototype._events = undefined;
EventEmitter.prototype._maxListeners = undefined;

// By default EventEmitters will print a warning if more than 10 listeners are
// added to it. This is a useful default which helps finding memory leaks.
EventEmitter.defaultMaxListeners = 10;

// Obviously not all Emitters should be limited to 10. This function allows
// that to be increased. Set to zero for unlimited.
EventEmitter.prototype.setMaxListeners = function(n) {
  if (!isNumber(n) || n < 0 || isNaN(n))
    throw TypeError('n must be a positive number');
  this._maxListeners = n;
  return this;
};

EventEmitter.prototype.emit = function(type) {
  var er, handler, len, args, i, listeners;

  if (!this._events)
    this._events = {};

  // If there is no 'error' event listener then throw.
  if (type === 'error') {
    if (!this._events.error ||
        (isObject(this._events.error) && !this._events.error.length)) {
      er = arguments[1];
      if (er instanceof Error) {
        throw er; // Unhandled 'error' event
      }
      throw TypeError('Uncaught, unspecified "error" event.');
    }
  }

  handler = this._events[type];

  if (isUndefined(handler))
    return false;

  if (isFunction(handler)) {
    switch (arguments.length) {
      // fast cases
      case 1:
        handler.call(this);
        break;
      case 2:
        handler.call(this, arguments[1]);
        break;
      case 3:
        handler.call(this, arguments[1], arguments[2]);
        break;
      // slower
      default:
        len = arguments.length;
        args = new Array(len - 1);
        for (i = 1; i < len; i++)
          args[i - 1] = arguments[i];
        handler.apply(this, args);
    }
  } else if (isObject(handler)) {
    len = arguments.length;
    args = new Array(len - 1);
    for (i = 1; i < len; i++)
      args[i - 1] = arguments[i];

    listeners = handler.slice();
    len = listeners.length;
    for (i = 0; i < len; i++)
      listeners[i].apply(this, args);
  }

  return true;
};

EventEmitter.prototype.addListener = function(type, listener) {
  var m;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events)
    this._events = {};

  // To avoid recursion in the case that type === "newListener"! Before
  // adding it to the listeners, first emit "newListener".
  if (this._events.newListener)
    this.emit('newListener', type,
              isFunction(listener.listener) ?
              listener.listener : listener);

  if (!this._events[type])
    // Optimize the case of one listener. Don't need the extra array object.
    this._events[type] = listener;
  else if (isObject(this._events[type]))
    // If we've already got an array, just append.
    this._events[type].push(listener);
  else
    // Adding the second element, need to change to array.
    this._events[type] = [this._events[type], listener];

  // Check for listener leak
  if (isObject(this._events[type]) && !this._events[type].warned) {
    var m;
    if (!isUndefined(this._maxListeners)) {
      m = this._maxListeners;
    } else {
      m = EventEmitter.defaultMaxListeners;
    }

    if (m && m > 0 && this._events[type].length > m) {
      this._events[type].warned = true;
      console.error('(node) warning: possible EventEmitter memory ' +
                    'leak detected. %d listeners added. ' +
                    'Use emitter.setMaxListeners() to increase limit.',
                    this._events[type].length);
      if (typeof console.trace === 'function') {
        // not supported in IE 10
        console.trace();
      }
    }
  }

  return this;
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

EventEmitter.prototype.once = function(type, listener) {
  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  var fired = false;

  function g() {
    this.removeListener(type, g);

    if (!fired) {
      fired = true;
      listener.apply(this, arguments);
    }
  }

  g.listener = listener;
  this.on(type, g);

  return this;
};

// emits a 'removeListener' event iff the listener was removed
EventEmitter.prototype.removeListener = function(type, listener) {
  var list, position, length, i;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events || !this._events[type])
    return this;

  list = this._events[type];
  length = list.length;
  position = -1;

  if (list === listener ||
      (isFunction(list.listener) && list.listener === listener)) {
    delete this._events[type];
    if (this._events.removeListener)
      this.emit('removeListener', type, listener);

  } else if (isObject(list)) {
    for (i = length; i-- > 0;) {
      if (list[i] === listener ||
          (list[i].listener && list[i].listener === listener)) {
        position = i;
        break;
      }
    }

    if (position < 0)
      return this;

    if (list.length === 1) {
      list.length = 0;
      delete this._events[type];
    } else {
      list.splice(position, 1);
    }

    if (this._events.removeListener)
      this.emit('removeListener', type, listener);
  }

  return this;
};

EventEmitter.prototype.removeAllListeners = function(type) {
  var key, listeners;

  if (!this._events)
    return this;

  // not listening for removeListener, no need to emit
  if (!this._events.removeListener) {
    if (arguments.length === 0)
      this._events = {};
    else if (this._events[type])
      delete this._events[type];
    return this;
  }

  // emit removeListener for all listeners on all events
  if (arguments.length === 0) {
    for (key in this._events) {
      if (key === 'removeListener') continue;
      this.removeAllListeners(key);
    }
    this.removeAllListeners('removeListener');
    this._events = {};
    return this;
  }

  listeners = this._events[type];

  if (isFunction(listeners)) {
    this.removeListener(type, listeners);
  } else {
    // LIFO order
    while (listeners.length)
      this.removeListener(type, listeners[listeners.length - 1]);
  }
  delete this._events[type];

  return this;
};

EventEmitter.prototype.listeners = function(type) {
  var ret;
  if (!this._events || !this._events[type])
    ret = [];
  else if (isFunction(this._events[type]))
    ret = [this._events[type]];
  else
    ret = this._events[type].slice();
  return ret;
};

EventEmitter.listenerCount = function(emitter, type) {
  var ret;
  if (!emitter._events || !emitter._events[type])
    ret = 0;
  else if (isFunction(emitter._events[type]))
    ret = 1;
  else
    ret = emitter._events[type].length;
  return ret;
};

function isFunction(arg) {
  return typeof arg === 'function';
}

function isNumber(arg) {
  return typeof arg === 'number';
}

function isObject(arg) {
  return typeof arg === 'object' && arg !== null;
}

function isUndefined(arg) {
  return arg === void 0;
}

},{}],12:[function(require,module,exports){
var deprecated = {
  method: function(msg, log, fn) {
    var called = false;
    return function(){
      if (!called) {
        called = true;
        log(msg);
      }
      return fn.apply(this, arguments);
    };
  },

  field: function(msg, log, parent, field, val) {
    var called = false;
    var getter = function(){
      if (!called) {
        called = true;
        log(msg);
      }
      return val;
    };
    var setter = function(v) {
      if (!called) {
        called = true;
        log(msg);
      }
      val = v;
      return v;
    };
    Object.defineProperty(parent, field, {
      get: getter,
      set: setter,
      enumerable: true
    });
    return;
  }
};

module.exports = deprecated;
},{}]},{},[1])


//# sourceMappingURL=ga-0.5.0-SNAPSHOT.js.map