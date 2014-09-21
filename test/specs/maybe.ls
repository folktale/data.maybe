# # Tests for the Maybe structure

/** ^
 * Copyright (c) 2013 Quildreen Motta
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
 */

spec = (require 'hifive')!
{for-all, data: { Any:BigAny, Int }, sized} = require 'claire'
Maybe = require '../../lib/'
{ok, throws} = require 'assert'

id = (a) -> a

Any = sized (-> 10), BigAny
{Just, Nothing} = Maybe


module.exports = spec 'Maybe', (o, spec) ->
  
  spec 'Constructors' (o) ->
    o 'Nothing' -> ok (Nothing!is-nothing)
    o 'Just' do
       for-all(Any).satisfy (a) ->
         Just(a).is-just
       .as-test!
    o 'fromNullable' ->
       ok (Maybe.fromNullable null).is-nothing
       ok (Maybe.fromNullable 1).is-just

  spec 'Nothings' (o) ->
    o 'ap should propagate' do
       for-all(Any).satisfy (a) ->
         Nothing!.ap(Just a).is-equal Just(a)
       .as-test!
    o 'map should propagate' ->
       ok Nothing!.map(id).is-nothing
    o 'chain should propagate' do
       for-all(Any).satisfy (a) ->
         Nothing!.chain(-> Just a).is-nothing
       .as-test!
    o 'toString' ->
       ok (Nothing!.toString! is 'Maybe.Nothing')
    o 'should equal only Nothing' ->
       ok (Nothing!.is-equal Nothing!)
       ok not (Nothing!.is-equal Just 1)
    o 'get should throw an error' ->
       throws (-> Nothing!.get!), TypeError
    o 'get-or-else should return the else part' do
       for-all(Any).satisfy (a) ->
         Nothing!.get-or-else(a) is a
       .as-test!
    o 'or-else should call the thunk' do
       for-all(Any).satisfy (a) ->
         Nothing!.or-else(-> a) is a
       .as-test!
    o 'cata should invoke the Nothing function' do
       for-all(Any, Any).satisfy (a, b) ->
         Nothing!.cata(Nothing: (-> a), Just: (-> b)) is a
       .as-test!
       
  spec 'Justs' (o) ->
    o 'toString' do
       for-all(Int).satisfy (a) ->
         Just(a).to-string! is "Maybe.Just(#a)"
       .as-test!
    o 'should equal structurally' do
       for-all(Any).satisfy (a) ->
         Just(a).is-equal Just(a)
       .as-test!
    o 'get should return the value' do
       for-all(Any).satisfy (a) ->
         Just(a).get! is a
       .as-test!
    o 'get-or-else should return the value' do
       for-all(Any, Any).satisfy (a, b) ->
         Just(a).get-or-else(b) is a
       .as-test!
    o 'or-else should return the monad' do
       for-all(Any).satisfy (a) ->
         Just(a).or-else(-> Nothing!).is-equal Just(a)
       .as-test!
    o 'cata should invoke the Just function' do
       for-all(Any, Any).satisfy (a, b) ->
         Just(a).cata(Nothing: (-> b), Just: (x) -> x) is a
       .as-test!
