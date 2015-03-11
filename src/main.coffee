{
  isObject
  isArray, isNotArray
  isNumeric
  isString
  isEmptyString
  isNotUndefined
  isUndefined
  isEqual
  isNotPrimitive
  isPrimitive
  xor
} = require './util'
debug = require('./debug_wrapper')

# throw error in a checker by default
DEFAULT_CALLBACK = (err) ->
  throw err if err?

class Checker
  constructor: (@name, @defaultMessage, @negate = false, @argc = 1) ->
    module.exports[@name] = => @check.apply @, arguments
    debug "registered checker '#{@name}'"

  check: ->
    message = arguments[@argc]
    callback = arguments[@argc + 1] || DEFAULT_CALLBACK
    if typeof message is 'function'
      callback = message
      message = null

    args = []
    Array::push.call args, arg for arg in Array::splice.call arguments, 0, @argc

    message ?= @getErrorMessage.apply @, args
    try
      @invokeError message unless xor @doCheck.apply(@, args), @negate
      callback null
    catch e
      callback e

  invokeError: ->
    throw new Error 'something went wrong'

  doCheck: ->
    false

  getErrorMessage: ->
    if typeof @defaultMessage is 'function'
      @defaultMessage.apply(@, arguments)
    else
      @defaultMessage

class ArgumentChecker extends Checker
  constructor: (name, negate, message = DEFAULT_MESSAGES.INVALID_ARGUMENT) ->
    super name, message, negate

  doCheck: (condition) ->
    isString(condition) or isNumeric(condition) or condition

  invokeError: (message) ->
    throw new IllegalArgumentError message

class NumberTypeChecker extends Checker
  constructor: (name, negate, message = DEFAULT_MESSAGES.INVALID_TYPE) ->
    super name, message, negate

  doCheck: (value) ->
    isNumeric value

  invokeError: (message) ->
    throw new InvalidTypeError message

class ContainsChecker extends Checker
  constructor: (name, negate, message) ->
    super name, message, negate, 2

  doCheck: (value, object) ->
    argumentChecker.check object, 'invalid collection value'

    switch
      when isString object
        not ((not isString value) or
             (value.length > object.length) or
             ((isEmptyString(object) ^ isEmptyString(value))) or
             (not (isEmptyString(object) or value in object)))
      when isArray object then value in object
      when isNumeric object then ~object.toString().indexOf value
      else value of object

  invokeError: (message) ->
    throw new UnknownValueError message

class EqualsChecker extends Checker
  constructor: (name, negate, message) ->
    super name, message, negate, 2

  doCheck: (actual, expected) ->
    argumentChecker.check isNotUndefined(expected), 'invalid value expected'
    isEqual actual, expected

  invokeError: (message) ->
    throw new UnknownValueError message

class DefinedChecker extends Checker
  constructor: (name, negate, message = DEFAULT_MESSAGES.UNDEFINED_VALUE) ->
    super name, message, negate

  doCheck: (value) ->
    isNotUndefined value

  invokeError: (message) ->
    throw new UndefinedValueError message

class EmptyChecker extends Checker
  constructor: (name, negate, message = DEFAULT_MESSAGES.ILLEGAL_VALUE) ->
    super name, message, negate

  doCheck: (value) ->
    value is null or isUndefined(value) or
      (isNotPrimitive(value) and
        ((hasOwnProperty.call(value, 'length') and value.length is 0) or
        (typeof value is 'object' and Object.keys(value).length is 0)))

  invokeError: (message) ->
    throw new IllegalValueError message

class StateChecker extends ArgumentChecker
  constructor: (name) ->
    super name, false, DEFAULT_MESSAGES.ILLEGAL_STATE

  invokeError: (message) ->
    throw new IllegalStateError message

class NullChecker extends Checker
  constructor: (name, negate, message = DEFAULT_MESSAGES.NULL_VALUE) ->
    super name, message, negate

  doCheck: (value) ->
    isUndefined(value) or value is null

  invokeError: (message) ->
    throw new IllegalValueError message

DEFAULT_MESSAGES =
  INVALID_ARGUMENT : 'invalid argument'
  INVALID_TYPE     : 'invalid type'
  UNKNOWN_VALUE    : 'unknown value'
  UNDEFINED_VALUE  : 'undefined value'
  ILLEGAL_VALUE    : 'illegal value'
  ILLEGAL_STATE    : 'illegal state'
  NULL_VALUE       : 'value is null'

AbstractError = (@message) ->
  Error.call(@)
  Error.captureStackTrace(@, arguments.callee)
  @name = arguments.callee?.caller?.name or 'Error'

AbstractError.prototype.__proto__ = Error.prototype

class IllegalArgumentError extends AbstractError

class InvalidTypeError extends AbstractError

class UnknownValueError extends AbstractError

class UndefinedValueError extends AbstractError

class IllegalValueError extends AbstractError

class IllegalStateError extends AbstractError

# export all preconditions
argumentChecker = new ArgumentChecker 'checkArgument'

new NumberTypeChecker 'checkNumberType'
new NumberTypeChecker 'checkNotNumberType', true

new ContainsChecker 'checkContains', false,
                    (value, object) -> "unknown value '#{value}'"
new ContainsChecker 'checkDoesNotContain', true,
                    (value, object) -> "'#{value}' is a known value"

new EqualsChecker 'checkEquals', false,
                  (actual, expected) ->
                    "expected '#{expected}' but got '#{actual}'"
new EqualsChecker 'checkDoesNotEqual', true,
                  (actual) -> "did not expect value '#{actual}'"

new DefinedChecker 'checkDefined'
new DefinedChecker 'checkUndefined', true,
                   (value) -> "'#{value}' is a defined value"

new EmptyChecker 'checkEmpty', false, (value) -> "'#{value}' is not empty"
new EmptyChecker 'checkNotEmpty', true

new StateChecker 'checkState'

new NullChecker 'checkNull', false, (value) -> "'#{value}' is not null"
new NullChecker 'checkNotNull', true

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError     = InvalidTypeError
module.exports.UnknownValueError    = UnknownValueError
module.exports.UndefinedValueError  = UndefinedValueError
module.exports.IllegalValueError    = IllegalValueError
module.exports.IllegalStateError    = IllegalStateError
