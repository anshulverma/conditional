{checkContains, UnknownValueError, IllegalArgumentError} = require '../src/main'

describe 'test contains precondition', ->
  it 'happy path test', ->
    wrapper = -> checkContains 'a', ['a', 'b', 'c']
    assert.doesNotThrow wrapper

  it 'empty string test', ->
    wrapper = -> checkContains '', ['a', 'b', ''], 'empty string present'
    assert.doesNotThrow wrapper

  it 'null value test', ->
    wrapper = -> checkContains null, ['a', 'b', 'null'], 'null value missing'
    assert.throws wrapper, UnknownValueError, 'null value missing'
    wrapper = -> checkContains null, ['a', 'b', null], 'null value present'
    assert.doesNotThrow wrapper

  it 'null and 0 are not same', ->
    wrapper = -> checkContains null, ['a', 'b', 0], 'null not present'
    assert.throws wrapper, UnknownValueError, 'null not present'
    wrapper = -> checkContains 0, ['a', 'b', null], '0 not present'
    assert.throws wrapper, UnknownValueError, '0 not present'

  it 'string and number are different types', ->
    wrapper = -> checkContains '5', ['a', 'b', 5], '5 not present'
    assert.throws wrapper, UnknownValueError, '5 not present'
    wrapper = -> checkContains 5, ['a', 'b', '5'], '5 not present'
    assert.throws wrapper, UnknownValueError, '5 not present'

  it 'object can be checked in array', ->
    obj1 = [1]
    obj2 = { 'test' }
    obj3 = null
    wrapper = ->
      checkContains obj1, [obj1, obj2, obj3]
      checkContains obj2, [obj1, obj2, obj3]
      checkContains obj3, [obj1, obj2, obj3]
    assert.doesNotThrow wrapper

  it 'a hash map can contain string keys', ->
    map = {
      val1: 1
      val2: 2
      val3: 3
    }
    wrapper = -> checkContains 'val1', map
    assert.doesNotThrow wrapper

  it 'a hash map can contain number keys', ->
    map = {
      1: 1
      2: 2
      3: 3
    }
    wrapper = -> checkContains 1, map
    assert.doesNotThrow wrapper

  it 'IllegalArgumentError is thrown for null collection object', ->
    wrapper = -> checkContains 'a', null, 'this message is hidden'
    assert.throws wrapper, IllegalArgumentError, 'invalid collection value'

  it 'IllegalArgumentError is not thrown for empty string collection object', ->
    wrapper = -> checkContains 's', ''
    assert.doesNotThrow wrapper, IllegalArgumentError

  it 'empty string can contain empty string', ->
    wrapper = -> checkContains '', ''
    assert.doesNotThrow wrapper

  it 'empty string cannot contain non-empty string', ->
    wrapper = -> checkContains 'str', ''
    assert.throws wrapper, UnknownValueError, "unknown value 'str'"

  it 'null is not contained in a string', ->
    wrapper = -> checkContains null, 'string'
    assert.throws wrapper, UnknownValueError, "unknown value 'null'"

  it 'null is not same as empty string', ->
    wrapper = -> checkContains null, ''
    assert.throws wrapper, UnknownValueError, "unknown value 'null'"

  it 'unequal string do not contain each other', ->
    wrapper = -> checkContains 'random', 'string'
    assert.throws wrapper, UnknownValueError, "unknown value 'random'"

  it 'equal strings also contain each other', ->
    wrapper = -> checkContains 'string', 'string'
    assert.doesNotThrow

  it 'substring of a string', ->
    wrapper = -> checkContains 'str', 'string'
    assert.doesNotThrow

  it 'check number contains another', ->
    wrapper = -> checkContains 1, 123
    assert.doesNotThrow wrapper

  it 'check number not present in another number', ->
    wrapper = -> checkContains 4, 123
    assert.throws wrapper, UnknownValueError, "unknown value '4'"

  it 'check string contained in number', ->
    wrapper = -> checkContains '1', 123
    assert.doesNotThrow wrapper

  it 'check string missing from number', ->
    wrapper = -> checkContains '4', 123
    assert.throws wrapper, UnknownValueError, "unknown value '4'"
