Monads.Maybe
============

[![Build Status](https://secure.travis-ci.org/folktale/monads.maybe.png?branch=master)](https://travis-ci.org/folktale/monads.maybe)
[![NPM version](https://badge.fury.io/js/monads.maybe.png)](http://badge.fury.io/js/monads.maybe)
[![Dependencies Status](https://david-dm.org/folktale/monads.maybe.png)](https://david-dm.org/folktale/monads.maybe)
[![experimental](http://hughsk.github.io/stability-badges/dist/experimental.svg)](http://github.com/hughsk/stability-badges)


A Monad for values that may not be present, or computations that may
fail. `Maybe(a)` explicitly models the effects that implicit in `Nullable`
types, thus has none of the problems associated with using `null` or
`undefined` — like `NullPointerException` or `TypeError`.

Furthermore, being a Monad, `Maybe(a)` can be composed in manners similar to
other monads, by using the generic sequencing and composition operations
provided for the common interface in
[Fantasy Land](https://github.com/fantasyland/fantasy-land).


## Example

```js
var Maybe = require('monads.maybe')

// :: [a], (a -> Bool) -> Maybe(a)
function find(collection, predicate) {
  for (var i = 0; i < collection.length; ++i) {
    var item = collection[i]
    if (predicate(item))  return Maybe.Just(item)
  }
  return Maybe.Nothing()
}

var numbers = [-2, -1, 0, 1, 2]
var a = find(numbers, function(a){ return a > 5 })
var b = find(numbers, function(a){ return a === 0 })

// Call a function only if both a and b have values (sequencing)
a.chain(function(x) {
  return b.chain(function(y) {
    doSomething(x, y)
  })
})

// Transform values only if they're available:
a.map(function(x){ return x + 1 })  // Maybe.Nothing
b.map(function(x){ return x + 1 })  // Maybe.Just(1)

// Use a default value if no value is present
a.orElse(function(){ return Maybe.Just(-1) })   // Maybe.Just(-1)
b.orElse(function(){ return Maybe.Just(-1) })   // Maybe.Just(0)
```


## Installing

The easiest way is to grab it from NPM:

    $ npm install monads.maybe
    
    
## Documentation

( TBD )


## Tests

( TBD )


## Platform support

This library assumes an ES5 environment, but can be easily supported in ES3
platforms by the use of shims. Just include [es5-shim][] :)

[es5-shim]: https://github.com/kriskowal/es5-shim


## Licence

Copyright (c) 2013 Quildreen Motta.

Released under the [MIT licence](https://github.com/folktale/monads.maybe/blob/master/LICENCE).

