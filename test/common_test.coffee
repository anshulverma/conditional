require './helpers/test_helper'

{
  checkArgument
  checkNumberType
  checkNotNumberType
  checkContains
  checkDoesNotContain
  checkEquals
  checkDoesNotEqual
  checkDefined
  checkUndefined
  checkEmpty
  checkNotEmpty
  checkState
  checkNull
  checkNotNull
  IllegalArgumentError
  InvalidTypeError
  UnknownValueError
  UndefinedValueError
  IllegalValueError
  IllegalStateError
} = preconditions

FORCED_ERROR = 'this must fail'

executors = [
  {
    name: 'argument'
    execFail: (errorMessage, callback) ->
      checkArgument false, errorMessage, callback
    execPass: (callback) -> checkArgument true, callback
    errorType: IllegalArgumentError
    defaultErrorMessage: 'invalid argument'
  }
  {
    name: 'type'
    execFail: (errorMessage, callback) ->
      checkNumberType 'string', errorMessage, callback
    execPass: (callback) -> checkNumberType 123, callback
    errorType: InvalidTypeError
    defaultErrorMessage: 'invalid type'
  }
  {
    name: 'not-type'
    execFail: (errorMessage, callback) ->
      checkNotNumberType 123, errorMessage, callback
    execPass: (callback) -> checkNotNumberType 'string', callback
    errorType: InvalidTypeError
    defaultErrorMessage: 'invalid type'
  }
  {
    name: 'contains'
    execFail: (errorMessage, callback) ->
      checkContains 'd', ['a', 'b', 'c'], errorMessage, callback
    execPass: (callback) -> checkContains 'a', ['a'], callback
    errorType: UnknownValueError
    defaultErrorMessage: "unknown value 'd'"
  }
  {
    name: 'not-contains'
    execFail: (errorMessage, callback) ->
      checkDoesNotContain 'a', ['a'], errorMessage, callback
    execPass: (callback) -> checkDoesNotContain 'd', ['a', 'b', 'c'], callback
    errorType: UnknownValueError
    defaultErrorMessage: "'a' is a known value"
  }
  {
    name: 'equals'
    execFail: (errorMessage, callback) ->
      checkEquals 'a', 'b', errorMessage, callback
    execPass: (callback) -> checkEquals true, true, callback
    errorType: UnknownValueError
    defaultErrorMessage: "expected 'b' but got 'a'"
  }
  {
    name: 'not-equals'
    execFail: (errorMessage, callback) ->
      checkDoesNotEqual true, true, errorMessage, callback
    execPass: (callback) ->
      checkDoesNotEqual 'a', 'b', callback
    errorType: UnknownValueError
    defaultErrorMessage: "did not expect value 'true'"
  }
  {
    name: 'defined'
    execFail: (errorMessage, callback) ->
      checkDefined {}.undefined, errorMessage, callback
    execPass: (callback) -> checkDefined true, callback
    errorType: UndefinedValueError
    defaultErrorMessage: 'undefined value'
  }
  {
    name: 'not-defined'
    execFail: (errorMessage, callback) ->
      checkUndefined true, errorMessage, callback
    execPass: (callback) -> checkUndefined {}.undefined, callback
    errorType: UndefinedValueError
    defaultErrorMessage: "'true' is a defined value"
  }
  {
    name: 'empty'
    execFail: (errorMessage, callback) ->
      checkEmpty 'string', errorMessage, callback
    execPass: (callback) -> checkEmpty '', callback
    errorType: IllegalValueError
    defaultErrorMessage: "'string' is not empty"
  }
  {
    name: 'not-empty'
    execFail: (errorMessage, callback) ->
      checkNotEmpty '', errorMessage, callback
    execPass: (callback) -> checkNotEmpty 'string', callback
    errorType: IllegalValueError
    defaultErrorMessage: 'illegal value'
  }
  {
    name: 'state'
    execFail: (errorMessage, callback) ->
      checkState false, errorMessage, callback
    execPass: (callback) -> checkState true, callback
    errorType: IllegalStateError
    defaultErrorMessage: 'illegal state'
  }
  {
    name: 'null'
    execFail: (errorMessage, callback) ->
      checkNull 'string', errorMessage, callback
    execPass: (callback) -> checkNull null, callback
    errorType: IllegalValueError
    defaultErrorMessage: "'string' is not null"
  }
  {
    name: 'not-null'
    execFail: (errorMessage, callback) ->
      checkNotNull null, errorMessage, callback
    execPass: (callback) -> checkNotNull 'string', callback
    errorType: IllegalValueError
    defaultErrorMessage: 'value is null'
  }
]

runTests = (test) ->
  for executor in executors
    test executor

describe 'common tests for preconditions', ->
  stackFrameSuite = if window? then describe.skip else describe
  stackFrameSuite 'error trace should not contain unwanted frames', ->
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
