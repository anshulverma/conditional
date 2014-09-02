{checkNotEmpty, IllegalValueError} = preconditions

describe 'test notEmpty precondition', ->
  it 'null is a empty value', ->
    wrapper = -> checkNotEmpty null, 'should not be null'
    assert.throws wrapper, IllegalValueError, 'should not be null'

  it 'undefined is a empty value', ->
    wrapper = -> checkNotEmpty {}.x, 'should not be undefined'
    assert.throws wrapper, IllegalValueError, 'should not be undefined'

  it 'empty array is a empty value', ->
    wrapper = -> checkNotEmpty [], 'should not be empty'
    assert.throws wrapper, IllegalValueError, 'should not be empty'

  it 'empty object is a empty value', ->
    wrapper = -> checkNotEmpty {}, 'should not be empty'
    assert.throws wrapper, IllegalValueError, 'should not be empty'

  it 'empty string is a empty value', ->
    wrapper = -> checkNotEmpty '', 'should not be empty'
    assert.throws wrapper, IllegalValueError, 'should not be empty'

  it '0 (zero) is not empty', ->
    wrapper = -> checkNotEmpty 0
    assert.doesNotThrow wrapper

  it 'boolean false is not empty', ->
    wrapper = -> checkNotEmpty false
    assert.doesNotThrow wrapper
