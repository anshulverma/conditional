{
  checkArgument
  checkNumberType
  checkContains
  checkEquals
  checkDefined
  checkNotEmpty
  IllegalArgumentError
  InvalidTypeError
  UnknownValueError
  UndefinedValueError
  IllegalValueError
} = preconditions

FORCED_ERROR = 'this must fail'

executors = [
  {
    name: 'argument'
    execFail: (errorMessage, callback) -> checkArgument false, errorMessage, callback
    execPass: (callback) -> checkArgument true, callback
    errorType: IllegalArgumentError
    defaultErrorMessage: 'invalid argument'
  }
  {
    name: 'type'
    execFail: (errorMessage, callback) -> checkNumberType 'string', errorMessage, callback
    execPass: (callback) -> checkNumberType 123, callback
    errorType: InvalidTypeError
    defaultErrorMessage: 'invalid type'
  }
  {
    name: 'contains'
    execFail: (errorMessage, callback) -> checkContains 'd', ['a', 'b', 'c'], errorMessage, callback
    execPass: (callback) -> checkContains 'a', ['a'], callback
    errorType: UnknownValueError
    defaultErrorMessage: "unknown value 'd'"
  }
  {
    name: 'equals'
    execFail: (errorMessage, callback) -> checkEquals 'a', 'b', errorMessage, callback
    execPass: (callback) -> checkEquals true, true, callback
    errorType: UnknownValueError
    defaultErrorMessage: "expected 'b' but got 'a'"
  }
  {
    name: 'defined'
    execFail: (errorMessage, callback) -> checkDefined {}.undefined, errorMessage, callback
    execPass: (callback) -> checkDefined true, callback
    errorType: UndefinedValueError
    defaultErrorMessage: 'undefined value'
  }
  {
    name: 'empty'
    execFail: (errorMessage, callback) -> checkNotEmpty '', errorMessage, callback
    execPass: (callback) -> checkNotEmpty 'string', callback
    errorType: IllegalValueError
    defaultErrorMessage: 'illegal value'
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
          executor.execFail FORCED_ERROR
          assert.fail "precondition #{executor.name} check should fail"
        catch e
          assert.equal e.message, FORCED_ERROR,
            "error message should be '#{FORCED_ERROR}'"
          assert.notMatch e.stack, /(main|util)\.(coffee|js)/,
            'stack trace should not contain unwanted frames'

  describe 'error message can be controlled by precondition call', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        wrapper = -> executor.execFail FORCED_ERROR
        assert.throws wrapper, executor.errorType, FORCED_ERROR

  describe 'preconditions return a default error message if none present', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        try
          do executor.execFail
          assert.fail 'expected an exception to be thrown'
        catch e
          assert.instanceOf e, executor.errorType
          assert.equal e.message, executor.defaultErrorMessage

  describe 'can call precondition with a callback', ->
    runTests (executor) ->
      it "#{executor.name} check", (done) ->
        executor.execFail FORCED_ERROR, (err) ->
          assert.equal FORCED_ERROR, err.message
          assert.instanceOf err, executor.errorType
          do done

  describe 'happy path test', ->
    runTests (executor) ->
      it "#{executor.name} check", ->
        assert.doesNotThrow executor.execPass

  describe 'happy path test with a callback', ->
    runTests (executor) ->
      it "#{executor.name} check", (done) ->
        executor.execPass (err) ->
          assert.isNull err, 'no error should be thrown in happy path'
          do done
