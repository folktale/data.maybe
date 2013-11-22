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

# ## Class: Abstract-Maybe
#
# Provides base values for the `Nothing` and `Just` cases.
class Abstract-Maybe
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
  is-just: false

  # ### Function: Nothing
  #
  # Constructs a new monad with an absent value.
  #
  # @type Unit -> Maybe(a)
  Nothing: -> new Nothing

  # ### Function: Just
  #
  # Constructs a new monad with one value.
  #
  # @type a -> Maybe(a)
  Just: (v) -> @of v



# ## Class: Maybe
#
# The `Maybe(a)` monad.
#
# @type Maybe(a) <: (Applicative, Functor, Monad, Recoverable, Eq, Show)
class Maybe extends Abstract-Maybe
  # ### Constructor
  #
  # Constructs a new `Maybe(a)` monad with a value `a`.
  #
  # @type a -> Maybe(a)
  (a) -> @value = a

  # ### Field: is-just
  #
  # Tests if the Monad holds a `Just` — the case with value.
  #
  # @type Boolean
  is-just: true

  # ### Section: Applicative ###########################################

  # #### Function: of
  #
  # Creates a new `Maybe(a)` monad with a value `a`.
  #
  # @type a -> Maybe(a)
  of: (v) -> new Maybe v

  # #### Function: ap
  #
  # Applies a function from inside of the `Maybe(a)` monad to another
  # `Applicative` type.
  #
  # @type (@Maybe(a -> b), f:Applicative) => f(a) -> f(b)
  ap: (b) -> b.map @value


  # ### Section: Functor ###############################################

  # #### Function: map
  #
  # Transforms the value of the `Maybe(a)` monad using a regular
  # function.
  #
  # @type @Maybe(a) => (a -> b) -> Maybe(b)
  map: (f) -> @of (f @value)


  # ### Section: Monad #################################################

  # #### Function: chain
  #
  # Transforms the value of the `Maybe(a)` monad using a function to a
  # monad of the same type.
  #
  # @type @Maybe(a) => (a -> Maybe(b)) -> Maybe(b)
  chain: (f) -> f @value


  # ### Section: Recoverable ###########################################

  # #### Function: or-else
  #
  # Applies a function if the `Maybe(a)` monad has no value.
  #
  # @type @Maybe(a) => (Unit -> Maybe(b)) -> Maybe(b)
  or-else: (f) -> this


  # ### Section: Show ##################################################

  # #### Function: to-string
  #
  # Returns a textual representation of the `Maybe(a)` monad.
  #
  # @type Unit -> String
  to-string: -> "Maybe.Just(#{@value})"


  # ### Seciton: Eq ####################################################

  # #### Function: is-equal
  #
  # Tests if a `Maybe(a)` monad is equal to another `Maybe(a)` monad.
  #
  # @type @Maybe(a) => Maybe(a) -> Boolean
  is-equal: (a) -> Boolean switch
    | @is-nothing           => a.is-nothing
    | @is-just && a.is-just => a.value is @value


# ## Class: Nothing
#
# The `Nothing` case for the `Maybe(a)` monad.
class Nothing extends Maybe
  ->
  is-nothing: true
  of: -> Nothing
  map: -> this
  chain: -> this
  ap: (b) -> b
  or-else: (f) -> f!
  to-string: -> "Maybe.Nothing"


# ## Exports
module.exports = Maybe
