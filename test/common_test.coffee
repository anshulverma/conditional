{
  checkArgument
  checkNumberType
  IllegalArgumentError
  InvalidTypeError
} = require '../src/main'

FORCED_ERROR = 'this must fail'

executors = [
  {
    name: 'argument check'
    execute: (errorMessage) -> checkArgument false, errorMessage
    errorType: IllegalArgumentError
    defaultErrorMessage: 'invalid argument'
  }
  {
    name: 'type check'
    execute: (errorMessage) -> checkNumberType 'string', errorMessage
    errorType: InvalidTypeError
    defaultErrorMessage: 'invalid type'
  }
]

runTests = (test) ->
  for executor in executors
    test executor

describe 'common tests for preconditions', ->
  describe 'error trace should not contain unwanted frames', ->
    runTests (executor) ->
      it "#{executor.name}", ->
        try
          executor.execute FORCED_ERROR
          assert.fail "precondition #{executor.name} should fail"
        catch e
          assert.equal e.message, FORCED_ERROR,
            "error message should be '#{FORCED_ERROR}'"
          assert.notInclude e.stack, 'main.coffee',
            'stack trace should not contain unwanted frames'

  describe 'error message can be controlled by precondition call', ->
    runTests (executor) ->
      it "#{executor.name}", ->
        wrapper = -> executor.execute FORCED_ERROR
        assert.throws wrapper, executor.errorType, FORCED_ERROR

  describe 'preconditions return a default error message if none present', ->
    runTests (executor) ->
      it "#{executor.name}", ->
        assert.throws executor.execute,
                      executor.errorType,
                      executor.defaultErrorMessage
