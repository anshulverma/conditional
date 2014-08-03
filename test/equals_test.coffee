{checkEquals, UnknownValueError} = require '../src/main'

describe 'test equality precondition', ->
  it 'string equality test', ->
    wrapper = -> checkEquals 'str', 'str', "expecting 'a'"
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals 'abc', 'xyz', 'invalid string'
    assert.throws wrapper, UnknownValueError, 'invalid string'

  it 'number equality test', ->
    wrapper = -> checkEquals 5, 5, 'number should be equal'
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals 123, 234, 'invalid number'
    assert.throws wrapper, UnknownValueError, 'invalid number'

  it 'boolean equality test', ->
    wrapper = -> checkEquals false, false, 'true value expected'
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals true, false, 'invalid string'
    assert.throws wrapper, UnknownValueError, 'invalid string'

  it 'string equality test', ->
    wrapper = -> checkEquals 'str', 'str', "expecting 'a'"
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals 'abc', 'xyz', 'invalid string'
    assert.throws wrapper, UnknownValueError, 'invalid string'

  it 'string equality test', ->
    wrapper = -> checkEquals 'str', 'str', "expecting 'a'"
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals 'abc', 'xyz', 'invalid string'
    assert.throws wrapper, UnknownValueError, 'invalid string'
