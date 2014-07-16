{checkNumberType, InvalidTypeError} = require '../src/main'

describe 'test number type precondition', ->
  it 'error message can be controlled by checkNumberType', ->
    wrapper = -> checkNumberType 'string', 'force type failure'
    assert.throws wrapper, InvalidTypeError, 'force type failure'

  it 'default error message', ->
    wrapper = -> checkNumberType []
    assert.throws wrapper, InvalidTypeError, 'invalid type'

  it 'happy path test', ->
    wrapper = -> checkNumberType 5, 'invalid numerical value'
    assert.doesNotThrow wrapper

  it "boolean 'true' values are not numbers", ->
    wrapper = -> checkNumberType true, 'invalid numerical value'
    assert.throws wrapper, InvalidTypeError, 'invalid numerical value'

  it "boolean 'false' values are not numbers", ->
    wrapper = -> checkNumberType false, 'invalid numerical value'
    assert.throws wrapper, InvalidTypeError, 'invalid numerical value'

  it 'arrays are not numbers', ->
    wrapper = -> checkNumberType [5], 'invalid numerical value'
    assert.throws wrapper, InvalidTypeError, 'invalid numerical value'

  it 'objects are not numbers', ->
    wrapper = -> checkNumberType new Object, 'invalid numerical value'
    assert.throws wrapper, InvalidTypeError, 'invalid numerical value'
