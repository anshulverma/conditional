{
  checkArgument, IllegalArgumentError
  checkState   , IllegalStateError
} = preconditions

runTests = (test) ->
  test 'argument', checkArgument, IllegalArgumentError
  test 'state'   , checkState   , IllegalStateError

runTests (name, checker, errorType) ->
  describe "test #{name} precondition", ->
    it 'happy path test', ->
      wrapper = -> checker true, 'valid argument'
      assert.doesNotThrow wrapper

    it "'null' condition value also results in a error", ->
      wrapper = -> checker null, "'null' is not allowed"
      assert.throws wrapper, errorType, "'null' is not allowed"

    it 'a non-undefined value for condition is valid', ->
      wrapper = -> checker 'random', 'a non-undefined value is allowed'
      assert.doesNotThrow wrapper

    it 'a empty string value for condition is valid', ->
      wrapper = -> checker '', 'a string value is allowed'
      assert.doesNotThrow wrapper

    it 'a numerical value 0 is valid', ->
      wrapper = -> checker 0, '0 (zero) value is allowed'
      assert.doesNotThrow wrapper
