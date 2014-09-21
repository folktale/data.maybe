Data.Maybe
==========

[![Build Status](https://secure.travis-ci.org/folktale/data.maybe.png?branch=master)](https://travis-ci.org/folktale/data.maybe)
[![NPM version](https://badge.fury.io/js/data.maybe.png)](http://badge.fury.io/js/data.maybe)
[![Dependencies Status](https://david-dm.org/folktale/data.maybe.png)](https://david-dm.org/folktale/data.maybe)
[![stable](http://hughsk.github.io/stability-badges/dist/stable.svg)](http://github.com/hughsk/stability-badges)


A structure for values that may not be present, or computations that may
fail. `Maybe(a)` explicitly models the effects that implicit in `Nullable`
types, thus has none of the problems associated with using `null` or
`undefined` — like `NullPointerException` or `TypeError`.

Furthermore, being a Monad, `Maybe(a)` can be composed in manners similar to
other monads, by using the generic sequencing and composition operations
provided for the common interface in
[Fantasy Land](https://github.com/fantasyland/fantasy-land).


## Example

```js
var Maybe = require('data.maybe')

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

// Call a function only if both a and b
// have values (sequencing)
a.chain(function(x) {
  return b.chain(function(y) {
    doSomething(x, y)
  })
})

// Transform values only if they're available:
a.map(function(x){ return x + 1 })
// => Maybe.Nothing
b.map(function(x){ return x + 1 })
// => Maybe.Just(1)

// Use a default value if no value is present
a.orElse(function(){ return Maybe.Just(-1) })
// => Maybe.Just(-1)
b.orElse(function(){ return Maybe.Just(-1) })
// => Maybe.Just(0)
```


## Installing

The easiest way is to grab it from NPM. If you're running in a Browser
environment, you can use [Browserify][]:

    $ npm install data.maybe


### Using with CommonJS

If you're not using NPM, [Download the latest release][release], and require
the `data.maybe.umd.js` file:

```js
var Maybe = require('data.maybe')
```


### Using with AMD

[Download the latest release][release], and require the `data.maybe.umd.js`
file:

```js
require(['data.maybe'], function(Maybe) {
  ( ... )
})
```


### Using without modules

[Download the latest release][release], and load the `data.maybe.umd.js`
file. The properties are exposed in the global `folktale.data.Maybe` object:

```html
<script src="/path/to/data.maybe.umd.js"></script>
```


### Compiling from source

If you want to compile this library from the source, you'll need [Git][],
[Make][], [Node.js][], and run the following commands:

    $ git clone git://github.com/folktale/data.maybe.git
    $ cd data.maybe
    $ npm install
    $ make bundle

This will generate the `dist/data.maybe.umd.js` file, which you can load in
any JavaScript environment.


## Documentation

You can [read the documentation online][docs] or build it yourself:

    $ git clone git://github.com/folktale/data.maybe.git
    $ cd data.maybe
    $ npm install
    $ make documentation

Then open the file `docs/index.html` in your browser.


## Platform support

This library assumes an ES5 environment, but can be easily supported in ES3
platforms by the use of shims. Just include [es5-shim][] :)


## Licence

Copyright (c) 2013 Quildreen Motta.

Released under the [MIT licence](https://github.com/folktale/data.maybe/blob/master/LICENCE).

<!-- links -->
[Fantasy Land]: https://github.com/fantasyland/fantasy-land
[Browserify]: http://browserify.org/
[Git]: http://git-scm.com/
[Make]: http://www.gnu.org/software/make/
[Node.js]: http://nodejs.org/
[es5-shim]: https://github.com/kriskowal/es5-shim
[docs]: http://folktale.github.io/data.maybe
<!-- [release: https://github.com/folktale/data.maybe/releases/download/v$VERSION/data.maybe-$VERSION.tar.gz] -->
[release]: https://github.com/folktale/data.maybe/releases/download/v1.1.0/data.maybe-1.1.0.tar.gz
<!-- [/release] -->
