{checkEquals, UnknownValueError, IllegalArgumentError} = preconditions

UNDEFINED = {}.xyz

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

  it 'object equality test', ->
    wrapper = -> checkEquals {val: 'a'}, {val: 'a'}, 'expecting {val: a}'
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals {val: 'a'}, {val: 'b'}, 'invalid object'
    assert.throws wrapper, UnknownValueError, 'invalid object'
    wrapper = -> checkEquals {val1: 'a'}, {val2: 'a'}, 'expecting {val2: a}'
    assert.throws wrapper, UnknownValueError, 'expecting {val2: a}'

  it 'undefined should not be expected', ->
    wrapper = -> checkEquals 'val', UNDEFINED
    assert.throws wrapper, IllegalArgumentError, 'invalid value expected'

  it 'nulls are equal', ->
    wrapper = -> checkEquals null, null, 'null value expected'
    assert.doesNotThrow wrapper

  it 'null is not same as undefined', ->
    wrapper = -> checkEquals UNDEFINED, null, 'null value expected'
    assert.throws wrapper, UnknownValueError, 'null value expected'

  it 'boolean false is not null or undefined', ->
    wrapper = -> checkEquals null, false, 'expecting false'
    assert.throws wrapper, UnknownValueError, 'expecting false'
    wrapper = -> checkEquals UNDEFINED, false, 'expecting false'
    assert.throws wrapper, UnknownValueError, 'expecting false'

  it 'numbers and string are not equal', ->
    wrapper = -> checkEquals '123', 123, 'expecting number'
    assert.throws wrapper, UnknownValueError, 'expecting number'

  # array equality tests
  it 'array equality test', ->
    wrapper = -> checkEquals ['a'], ['a'], 'expecting [a]'
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals ['b'], ['a'], 'expecting [a]'
    assert.throws wrapper, UnknownValueError, 'expecting [a]'

  it 'empty arrays are equal', ->
    wrapper = -> checkEquals [], [], 'expecting empty array'
    assert.doesNotThrow wrapper

  it 'arrays of different length are not equal', ->
    wrapper = -> checkEquals ['a', 'b'], ['a', 'b', 'c'], 'expecting length 3'
    assert.throws wrapper, UnknownValueError, 'expecting length 3'
    wrapper = -> checkEquals ['a', 'b', 'c'], ['a', 'b'], 'expecting length 2'
    assert.throws wrapper, UnknownValueError, 'expecting length 2'

  it 'array contains null values are equal', ->
    wrapper = -> checkEquals [null, null], [null, null], 'expecting 2 nulls'
    assert.doesNotThrow wrapper

  it 'array containing undefined values are not equal', ->
    wrapper = -> checkEquals [UNDEFINED], [UNDEFINED], 'expecting undefined'
    assert.throws wrapper, UnknownValueError, 'expecting undefined'

  it 'multidimensional array equality test', ->
    wrapper = -> checkEquals [[1, 2], [3, 4], ['a', ['b']]],
                             [[1, 2], [3, 4], ['a', ['b']]]
    assert.doesNotThrow wrapper
    wrapper = -> checkEquals [[1, 2], [3, 4], ['a', ['b']]],
                             [[1, 2], [3, 4], ['a', ['b', 'c']]],
                             'expecting abc'
    assert.throws wrapper, UnknownValueError, 'expecting abc'
