{checkArgument} = require '../src/main'

describe 'Preconditions', ->
  describe '#arguments', ->
    it '#messageAndStack', ->
      try
        checkArgument false, 'this must fail'
        assert.fail 'precondition arg check should fail for false condition'
      catch e
        assert.equal e.message, 'this must fail',
          "error's message should be same as the one passed in the check call"
        assert.notInclude e.stack, 'main.coffee',
          'stack trace should not contain unwanted frames'
