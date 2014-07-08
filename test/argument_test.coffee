{checkArgument, IllegalArgumentError} = require '../src/main'

describe 'test argument precondition', ->
  it 'error message should be controlled by checkArgument call', ->
    wrapper = -> checkArgument false, 'force failure'
    assert.throws wrapper, IllegalArgumentError, 'force failure'

  it 'default value for error message', ->
    wrapper = -> checkArgument false
    assert.throws wrapper, IllegalArgumentError, 'invalid argument'

  it 'error stack trace should not contain unwanted frames', ->
    try
      checkArgument false, 'this must fail'
      assert.fail 'precondition arg check should fail for false condition'
    catch e
      assert.equal e.message, 'this must fail',
        "error's message should be same as the one passed in the check call"
      assert.notInclude e.stack, 'main.coffee',
        'stack trace should not contain unwanted frames'

  it 'happy path test', ->
    wrapper = -> checkArgument true, 'valid argument'
    assert.doesNotThrow wrapper

  it "'null' condition value also results in a error", ->
    wrapper = -> checkArgument null, "'null' is not allowed"
    assert.throws wrapper, IllegalArgumentError,
      "'null' is not allowed"

  it 'a non-undefined value for condition is valid', ->
    wrapper = -> checkArgument 'random', 'a non-undefined value is allowed'
    assert.doesNotThrow wrapper
