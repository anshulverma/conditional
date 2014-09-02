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
  precondition
} = require './util'

DEFAULT_MESSAGES =
  INVALID_ARGUMENT : 'invalid argument'
  INVALID_TYPE     : 'invalid type'
  UNKNOWN_VALUE    : 'unknown value'
  UNDEFINED_VALUE  : 'undefined value'
  ILLEGAL_VALUE    : 'illegal value'

checkArgument = (condition, message) ->
  throw new IllegalArgumentError(message) unless isString(condition) or
                                                 isNumeric(condition) or
                                                 condition

checkNumberType = (value, message) ->
  throw new InvalidTypeError(message) unless isNumeric value

checkContains = (value, object, message = "unknown value '#{value}'") ->
  checkArgument object?, 'invalid collection value'

  invokeError = ->
    throw new UnknownValueError(message)

  switch
    when isString object
      if (not isString value) or
         (value.length > object.length) or
         ((isEmptyString(object) ^ isEmptyString(value))) or
         (not (isEmptyString(object) or value in object))
        do invokeError
    when isArray object then do invokeError unless value in object
    when isNumeric object then do invokeError unless ~object.toString().indexOf value
    else do invokeError unless value of object

checkEquals = (actual,
               expected,
               message = "expected '#{expected}' but got '#{actual}'") ->
  checkArgument isNotUndefined(expected), 'invalid value expected'
  throw new UnknownValueError(message) unless isEqual actual, expected

checkDefined = (value, message) ->
  throw new UndefinedValueError message if isUndefined(value) or not value?

checkNotEmpty = (value, message) ->
  invokeError = ->
    throw new IllegalValueError message

  return if isPrimitive value

  if value is null or isUndefined(value) or value.length is 0
    do invokeError
  else
    hasOwnProperty = Object.prototype.hasOwnProperty
    for key of value
      return if (hasOwnProperty.call(value, key))
    do invokeError

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

# hide this file from the stack trace
{trimStackTrace} = require './error_handler'
trimStackTrace __filename

# export all preconditions
module.exports.checkArgument   = precondition checkArgument, DEFAULT_MESSAGES.INVALID_ARGUMENT, 1
module.exports.checkNumberType = precondition checkNumberType, DEFAULT_MESSAGES.INVALID_TYPE, 1
module.exports.checkContains   = precondition checkContains, null, 2
module.exports.checkEquals     = precondition checkEquals, null, 2
module.exports.checkDefined    = precondition checkDefined, DEFAULT_MESSAGES.UNDEFINED_VALUE, 1
module.exports.checkNotEmpty   = precondition checkNotEmpty, DEFAULT_MESSAGES.ILLEGAL_VALUE, 1

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError     = InvalidTypeError
module.exports.UnknownValueError    = UnknownValueError
module.exports.UndefinedValueError  = UndefinedValueError
module.exports.IllegalValueError    = IllegalValueError
