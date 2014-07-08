{checkArgument, IllegalArgumentError} = require '../src/main'

describe 'Preconditions', ->
  describe '#arguments', ->
    it '#message', ->
      wrapper = -> checkArgument false, 'force failure'
      assert.throws wrapper, IllegalArgumentError, 'force failure'

    it '#defaultMessage', ->
      wrapper = -> checkArgument false
      assert.throws wrapper, IllegalArgumentError, 'invalid argument'

    it '#stack', ->
      try
        checkArgument false, 'this must fail'
        assert.fail 'precondition arg check should fail for false condition'
      catch e
        assert.equal e.message, 'this must fail',
          "error's message should be same as the one passed in the check call"
        assert.notInclude e.stack, 'main.coffee',
          'stack trace should not contain unwanted frames'

    it '#happyPath', ->
      wrapper = -> checkArgument true, 'valid argument'
      assert.doesNotThrow wrapper

    it '#undefined', ->
      wrapper = -> checkArgument null, "'null' is not allowed"
      assert.throws wrapper, IllegalArgumentError,
        "'null' is not allowed"

    it '#defined', ->
      wrapper = -> checkArgument 'random', 'a non-undefined value is allowed'
      assert.doesNotThrow wrapper
