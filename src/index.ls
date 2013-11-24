# # Monad: Maybe(a)
#
# A Monad for values that may not be present, or computations that may
# fail. `Maybe(a)` explicitly models the effects that are implicit in
# `Nullable` types, thus has none of the problems associated with `null`
# or `undefined` — like `NullPointerExceptions`.

/** ^
 * Copyright (c) 2013 Quildreen "Sorella" Motta <quildreen@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * + module: monads.maybe
 * + author: Quildreen Motta
 * + exports: Maybe
 */

# The class models two different cases:

#  +  `Just a` — represents a `Maybe(a)` that contains a value. `a` may be
#     any value, including `null` or `undefined`.
#  +  `Nothing` — represents a `Maybe(a)` that has no values. Or a
#     failure that needs no additional information.

# Common uses of this monad includes modelling values that may or may
# not be present in a collection, thus instead of needing a
# `collection.has(a)`, the `collection.get(a)` operation gives you all
# the information you need — `collection.get(a).is-nothing` being
# equivalent to `collection.has(a)`; Similarly the same reasoning may be
# applied to computations that may fail to provide a value, e.g.:
# `collection.find(predicate)` can safely return a `Maybe(a)` instance,
# even if the collection contains nullable values.

# Furthermore, the values of `Maybe(a)` can be combined and manipulated
# by using the expressive monadic operations. This allows safely
# sequencing operations that may fail, and safely composing values that
# you don't know whether they're present or not, failing early
# (returning a `Nothing`) if any of the operations fail.

# If one wants to store additional information about failures, the
# [Either][] and [Validation][] monads provide such a capability, and
# should be used instead of the `Maybe(a)` monad.

# [Either]: https://github.com/folktale/monads.either
# [Validation]: https://github.com/folktale/monads.validation


# ## Class: Maybe(a)
#
# The `Maybe(a)` monad.
class Maybe
  ->
 
  # ### Section: Constructors ##########################################

  # #### Function: Nothing
  #
  # Constructs a new `Maybe(a)` monad with an absent value — i.e.:
  # represents a failure.
  #  
  # + type: Unit -> Maybe(a)
  Nothing: -> Nothing

  # #### Function: Just
  #
  # Constructs a new `Maybe(a)` monad that holds the single value `a`.
  #
  # `a` can be any value, including `null`, `undefined` or another
  # `Maybe(a)` monad.
  #  
  # + type: a -> Maybe(a)
  Just: (a) -> new Just(a)

  # #### Function: from-nullable
  #
  # Constructs a new `Maybe(a)` monad from a nullable type. If the value
  # is either `null` or `undefined`, this function returns a `Nothing`,
  # otherwise the value is wrapped in a `Just(a)`.
  #  
  # + type: a -> Maybe(a)
  from-nullable: (a) ->
    | a? => new Just(a)
    | _  => Nothing


  # ### Section: Predicates ############################################
  
  # #### Field: is-nothing
  #
  # True if the `Maybe(a)` monad contains a failure (i.e.: `Nothing`).
  #  
  # + type: Boolean
  is-nothing: false

  # #### Field: is-just
  #
  # True if the `Maybe(a)` monad contains a single value (i.e.:
  # `Just(a)`).
  #  
  # + type: Boolean
  is-just: false


  # ### Section: Applicative ###########################################

  # #### Function: of
  #
  # Creates a new `Maybe(a)` monad holding the single value `a`.
  #  
  # `a` can be any value, includding `null`, `undefined` or another
  # `Maybe(a)` monad.
  #  
  # + type: a -> Maybe(a)
  of: (a) -> new Just(a)


  # #### Function: ap
  #
  # Applies the function inside the `Maybe(a)` monad to another
  # applicative type.
  #  
  # The `Maybe(a)` monad should contain a function value, otherwise a
  # `TypeError` is thrown.
  #  
  # + type: (@Maybe(a -> b), f:Applicative) => f(a) -> f(b)
  ap: (_) -> ...


  # ### Section: Functor ###############################################

  # #### Function: map
  #
  # Transforms the value of the `Maybe(a)` monad using a regular unary
  # function.
  #  
  # + type: (@Maybe(a)) => (a -> b) -> Maybe(b)
  map: (_) -> ...


  # ### Section: Chain #################################################

  # #### Function: chain
  #
  # Transforms the value of the `Maybe(a)` monad using an unary function
  # to a monad of the same type.
  #  
  # + type: (@Maybe(a)) => (a -> Maybe(b)) -> Maybe(b)
  chain: (_) -> ...


  # ### Section: Show ##################################################

  # #### Function: to-string
  #
  # Returns a textual representation of the `Maybe(a)` monad.
  #  
  # + type: (@Maybe(a)) => Unit -> String
  to-string: -> ...


  # ### Section: Eq ####################################################

  # #### Function: is-equal
  #
  # Tests if a `Maybe(a)` monad is equal to another `Maybe(a)` monad.
  #  
  # + type: (@Maybe(a)) => Maybe(a) -> Boolean
  is-equal: (_) -> ...


  # ### Section: Extracting and Recovering #############################

  # #### Function: get
  #
  # Extracts the value out of the `Maybe(a)` monad, if it
  # exists. Otherwise throws a `TypeError`.
  #  
  # + see: get-or-else — A getter that can handle failures.
  # + type: (@Maybe(a), *throws) => Unit -> a
  # + throws: TypeError — if the monad has no value (`Nothing`).
  get: -> ...

  # #### Function: get-or-else
  #
  # Extracts the value out of the `Maybe(a)` monad. If there is no
  # value, returns the given default.
  #  
  # + type: (@Maybe(a)) => a -> a
  get-or-else: (_) -> ...

  # #### Function: or-else
  #
  # Transforms a failure into a new `Maybe(a)` monad. Does nothing if
  # the monad already contains a value.
  #  
  # + type: (@Maybe(a)) => (Unit -> Maybe(a)) -> Maybe(a)
  or-else: (_) -> ...


# ## Class: Just(a)
#
# Represents a `Maybe(a)` holding a value.
class Just extends Maybe
  (@value) ->
  is-just: true
  ap: (b) -> b.map @value
  map: (f) -> @of (f @value)
  chain: (f) -> f @value
  to-string: -> "Maybe.Just(#{@value})"
  is-equal: (a) -> a.is-just and (a.value is @value)
  get: -> @value
  get-or-else: (a) -> @value
  or-else: -> this
  

# ## Object: Nothing
#
# A singleton representing a `Maybe(a)` holding no value.
Nothing = new class extends Maybe
  ->
  is-nothing: true
  ap: (b) -> b
  map: (f) -> this
  chain: (f) -> this
  to-string: -> "Maybe.Nothing"
  is-equal: (a) -> a.is-nothing
  get: -> throw new TypeError("Can't extract the value of a Nothing")
  get-or-else: (a) -> a
  or-else: (f) -> f!
  

# ## Exports
module.exports = new Maybe
