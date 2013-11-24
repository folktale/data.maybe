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
 * @module monads.maybe
 * @author Quildreen Motta
 * @exports Maybe
 */


# ## Trait: Applicative
Applicative =
  # ### Function: of
  #
  # Creates a new `Maybe(a)` monad with a value `a`.
  #
  # @type a -> Maybe(a)
  of: (v) -> new Maybe v

  # ### Function: ap
  #
  # Applies a function from inside of the `Maybe(a)` monad to another
  # `Applicative` type.
  #
  # @type (@Maybe(a -> b), f:Applicative) => f(a) -> f(b)
  ap: (b) -> b.map @value


# ## Trait: Functor
Functor =
  # ### Function: map
  #
  # Transforms the value of the `Maybe(a)` monad using a regular
  # function.
  #
  # @type @Maybe(a) => (a -> b) -> Maybe(b)
  map: (f) -> @of (f @value)


# ## Trait: Monad
Monad =
  # ### Function: chain
  #
  # Transforms the value of the `Maybe(a)` monad using a function to a
  # monad of the same type.
  #
  # @type @Maybe(a) => (a -> Maybe(b)) -> Maybe(b)
  chain: (f) -> f @value


# ## Trait: Show
Show =
  # ### Function: to-string
  #
  # Returns a textual representation of the `Maybe(a)` monad.
  #
  # @type Unit -> String
  to-string: -> "Maybe.Just(#{@value})"
  

# ## Trait: Eq
Eq =
  # ### Function: is-equal
  #
  # Tests if a `Maybe(a)` monad is equal to another `Maybe(a)` monad.
  #
  # @type @Maybe(a) => Maybe(a) -> Boolean
  is-equal: (a) -> a.is-just && a.value is @value


# ## Trait: Recoverable
Recoverable =
  # ### Function: or-else
  #
  # Applies a function if the `Maybe(a)` monad has no value.
  #
  # @type @Maybe(a) => (Unit -> Maybe(b)) -> Maybe(b)
  or-else: (_) -> this


# ## Class: Maybe
#
# The `Maybe(a)` monad.
class Maybe \
implements Applicative, Functor, Monad, Show, Eq, Recoverable
  # ### Constructor
  #
  # Constructs a new `Maybe(a)` monad with a value `a`.
  #
  # @type a -> Maybe(a)
  (a) -> @value = a

  # ### Function: Nothing
  #
  # Constructs a new monad with an absent value.
  #
  # @type Unit -> Maybe(a)
  @Nothing = -> Nothing

  # ### Function: Just
  #
  # Constructs a new monad with one value.
  #
  # @type a -> Maybe(a)
  @Just = (v) -> new Maybe v
  
  # ### Field: is-nothing
  # 
  # Tests if the Monad contains a `Nothing` — no value case..
  #
  # @type Boolean
  is-nothing: false

  # ### Field: is-just
  #
  # Tests if the Monad contains a `Just` — single value case.
  #
  # @type Boolean
  is-just: true

  # ### Function: get
  #
  # Tries to return the value in the monad, throws an error if there's
  # no value.
  #
  # @type @Maybe(a) => a  :: throws Error
  get: -> @value
  
  # ### Function: get-or-else
  #
  # Tries to return the value in the monad, fallsback to the given
  # default value.
  #
  # @type @Maybe(a) => a -> a
  get-or-else: (_) -> @value


# ## Class: Nothing
#
# The `Nothing` case for the `Maybe(a)` monad.
Nothing = new class extends Maybe
  ->
  is-nothing  : true
  is-just     : false

  ap          : (b) -> b

  map         : -> this

  chain       : -> this

  or-else     : (f) -> f!
  get         : -> throw new Error "Can't get() the value of Nothing."
  get-or-else : (a) -> a

  to-string   : -> "Maybe.Nothing"

  is-equal    : (a) -> a.is-nothing


# ## Exports
module.exports = Maybe
