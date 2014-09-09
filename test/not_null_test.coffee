{checkNull, checkNotNull, IllegalValueError} = preconditions

describe 'not null precondition test', ->
  it 'undefined is null', ->
    wrapper = -> checkNotNull {}.x, 'not expecting null'
    assert.throws wrapper, IllegalValueError, 'not expecting null'
    wrapper = -> checkNull {}.x, 'null expected'
    assert.doesNotThrow wrapper

  it 'empty string is not null', ->
    wrapper = -> checkNotNull ''
    assert.doesNotThrow wrapper

  it 'empty array is not null', ->
    wrapper = -> checkNotNull []
    assert.doesNotThrow wrapper

  it 'empty object is not null', ->
    wrapper = -> checkNotNull {}
    assert.doesNotThrow wrapper

  it 'boolean is not null', ->
    wrapper = -> checkNotNull false
    assert.doesNotThrow wrapper
    wrapper = -> checkNull true
    assert.throws wrapper, IllegalValueError, "'true' is not null"

  it '0 (zero) is not null', ->
    wrapper = -> checkNotNull 0
    assert.doesNotThrow wrapper
    wrapper = -> checkNull 0
    assert.throws wrapper, IllegalValueError, "'0' is not null"
