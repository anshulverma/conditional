{checkDefined} = preconditions

describe 'test defined precondition', ->
  it 'empty string is not undefined', ->
    wrapper = -> checkDefined '', 'expecting empty string'
    assert.doesNotThrow wrapper

  it '0 is not undefined', ->
    wrapper = -> checkDefined 0, 'expecting zero'
    assert.doesNotThrow wrapper

  it 'empty array is not undefined', ->
    wrapper = -> checkDefined [], 'expecting empty array'
    assert.doesNotThrow wrapper

  it 'empty object is not undefined', ->
    wrapper = -> checkDefined {}, 'expecting empty object'
    assert.doesNotThrow wrapper

  it 'null is a defined value', ->
    wrapper = -> checkDefined null, 'expecting null'
    assert.doesNotThrow wrapper

  it 'test for undefined keyword', ->
    wrapper = -> checkDefined undefined, 'should fail'
    assert.throws wrapper, 'should fail'
