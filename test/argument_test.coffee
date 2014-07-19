{checkArgument, IllegalArgumentError} = require '../src/main'

describe 'test argument precondition', ->
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

  it 'a empty string value for condition is valid', ->
    wrapper = -> checkArgument '', 'a string value is allowed'
    assert.doesNotThrow wrapper

  it 'a numerical value 0 is valid', ->
    wrapper = -> checkArgument 0, '0 (zero) value is allowed'
    assert.doesNotThrow wrapper
