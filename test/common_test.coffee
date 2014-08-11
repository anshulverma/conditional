{
  checkArgument
  checkNumberType
  checkContains
  checkEquals
  checkDefined
  IllegalArgumentError
  InvalidTypeError
  UnknownValueError
  UndefinedValueError
} = preconditions

FORCED_ERROR = 'this must fail'

executors = [
  {
    name: 'argument'
    execute: (errorMessage) -> checkArgument false, errorMessage
    errorType: IllegalArgumentError
    defaultErrorMessage: 'invalid argument'
  }
  {
    name: 'type'
    execute: (errorMessage) -> checkNumberType 'string', errorMessage
    errorType: InvalidTypeError
    defaultErrorMessage: 'invalid type'
  }
  {
    name: 'contains'
    execute: (errorMessage) -> checkContains 'd', ['a', 'b', 'c'], errorMessage
    errorType: UnknownValueError
    defaultErrorMessage: "unknown value 'd'"
  }
  {
    name: 'equals'
    execute: (errorMessage) -> checkEquals 'a', 'b', errorMessage
    errorType: UnknownValueError
    defaultErrorMessage: "expected 'b' but got 'a'"
  }
  {
    name: 'defined'
    execute: (errorMessage) -> checkDefined {}.undefined, errorMessage
    errorType: UnknownValueError
    defaultErrorMessage: "undefined value"
  }
]

runTests = (test) ->
  for executor in executors
    test executor

describe 'common tests for preconditions', ->
  describe 'error trace should not contain unwanted frames', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        try
          executor.execute FORCED_ERROR
          assert.fail "precondition #{executor.name} check should fail"
        catch e
          assert.equal e.message, FORCED_ERROR,
            "error message should be '#{FORCED_ERROR}'"
          assert.notMatch e.stack, /main\.(coffee|js)/,
            'stack trace should not contain unwanted frames'

  describe 'error message can be controlled by precondition call', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        wrapper = -> executor.execute FORCED_ERROR
        assert.throws wrapper, executor.errorType, FORCED_ERROR

  describe 'preconditions return a default error message if none present', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        assert.throws executor.execute,
                      executor.errorType,
                      executor.defaultErrorMessage
