{
  isObject
  isArray, isNotArray
  isNumeric
  isString
  isEmptyString
  isNotUndefined
  isUndefined
  isEqual
  isPrimitive
} = require './util'

# throw error in a checker by default
DEFAULT_CALLBACK = (err) ->
  throw err if err?

class Checker
  constructor: (@name, @argc = 1) ->
    module.exports[@name] = => @check.apply @, arguments

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
      @invokeError message unless @doCheck.apply @, args
      callback null
    catch e
      callback e

  invokeError: ->
    throw new Error 'something went wrong'

  doCheck: ->
    false

  getErrorMessage: ->
    null

class ArgumentChecker extends Checker
  constructor: (name = 'checkArgument') ->
    super name

  doCheck: (condition) ->
    isString(condition) or isNumeric(condition) or condition

  invokeError: (message) ->
    throw new IllegalArgumentError message

  getErrorMessage: ->
    DEFAULT_MESSAGES.INVALID_ARGUMENT

class NumberTypeChecker extends Checker
  constructor: ->
    super 'checkNumberType'

  doCheck: (value) ->
    isNumeric value

  invokeError: (message) ->
    throw new InvalidTypeError message

  getErrorMessage: ->
    DEFAULT_MESSAGES.INVALID_TYPE

class ContainsChecker extends Checker
  constructor: ->
    super 'checkContains', 2

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

  getErrorMessage: (value, object) ->
    "unknown value '#{value}'"

class EqualsChecker extends Checker
  constructor: ->
    super 'checkEquals', 2

  doCheck: (actual, expected) ->
    argumentChecker.check isNotUndefined(expected), 'invalid value expected'
    isEqual actual, expected

  invokeError: (message) ->
    throw new UnknownValueError message

  getErrorMessage: (actual, expected) ->
    "expected '#{expected}' but got '#{actual}'"

class DefinedChecker extends Checker
  constructor: ->
    super 'checkDefined'

  doCheck: (value) ->
    isNotUndefined value

  invokeError: (message) ->
    throw new UndefinedValueError message

  getErrorMessage: ->
    DEFAULT_MESSAGES.UNDEFINED_VALUE

class NotEmptyChecker extends Checker
  constructor: ->
    super 'checkNotEmpty'

  doCheck: (value) ->
    value isnt null and isNotUndefined(value) and
      (isPrimitive(value) or
      (hasOwnProperty.call(value, 'length') and value.length isnt 0) or
      (typeof value is 'object' and Object.keys(value).length isnt 0))

  invokeError: (message) ->
    throw new IllegalValueError message

  getErrorMessage: ->
    DEFAULT_MESSAGES.ILLEGAL_VALUE


class StateChecker extends ArgumentChecker
  constructor: ->
    super 'checkState'

  invokeError: (message) ->
    throw new IllegalStateError message

  getErrorMessage: ->
    DEFAULT_MESSAGES.ILLEGAL_STATE

DEFAULT_MESSAGES =
  INVALID_ARGUMENT : 'invalid argument'
  INVALID_TYPE     : 'invalid type'
  UNKNOWN_VALUE    : 'unknown value'
  UNDEFINED_VALUE  : 'undefined value'
  ILLEGAL_VALUE    : 'illegal value'
  ILLEGAL_STATE    : 'illegal state'

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

# hide this file from the stack trace
{trimStackTrace} = require './error_handler'
trimStackTrace __filename

# export all preconditions
argumentChecker = new ArgumentChecker
new NumberTypeChecker
new ContainsChecker
new EqualsChecker
new DefinedChecker
new NotEmptyChecker
new StateChecker

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError     = InvalidTypeError
module.exports.UnknownValueError    = UnknownValueError
module.exports.UndefinedValueError  = UndefinedValueError
module.exports.IllegalValueError    = IllegalValueError
module.exports.IllegalStateError    = IllegalStateError
