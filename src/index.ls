class Abstract-Maybe
  is-nothing: false
  is-just: false
  Nothing: -> Nothing
  Just: (v) -> @of v


class Maybe extends Abstract-Maybe
  ->
  is-just: true
  of: (v) -> new Maybe <<< value: v
  ap: (b) -> b.map @value
  map: (f) -> @of (f @value)
  chain: (f) -> f @value
  or-else: (f) -> this
  to-string: -> "Maybe.Just(#{@value})"
  is-equal: (a) -> Boolean switch
    | @is-nothing           => a.is-nothing
    | @is-just && a.is-just => a.value is @value


class Nothing extends Maybe
  ->
  is-nothing: true
  of: -> Nothing
  map: -> this
  chain: -> this
  ap: (b) -> b
  or-else: (f) -> f!
  to-string: -> "Maybe.Nothing"


module.exports = Maybe
