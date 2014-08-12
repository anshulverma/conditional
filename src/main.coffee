{
  isObject
  isArray, isNotArray
  isNumeric
  isString
  isEmptyString
  isNotUndefined
  isUndefined
  isEqual
} = require './util'

DEFAULT_CALLBACK = (err) ->
  throw err if err?

checkArgument = (condition, message = 'invalid argument', callback = DEFAULT_CALLBACK) ->
  callback new IllegalArgumentError(message) unless isString(condition) or
                                                    isNumeric(condition) or
                                                    condition

checkNumberType = (value, message = 'invalid type', callback = DEFAULT_CALLBACK) ->
  callback new InvalidTypeError(message) unless isNumeric value

checkContains = (value,
                 object,
                 message = "unknown value '#{value}'",
                 callback = DEFAULT_CALLBACK) ->
  checkArgument object?, 'invalid collection value'

  invokeError = ->
    callback new UnknownValueError(message)

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
               message = "expected '#{expected}' but got '#{actual}'",
               callback = DEFAULT_CALLBACK) ->
  checkArgument isNotUndefined(expected), 'invalid value expected'
  callback new UnknownValueError(message) unless isEqual actual, expected

checkDefined = (value, message = 'undefined value', callback = DEFAULT_CALLBACK) ->
  callback new UndefinedValueError message if isUndefined value

AbstractError = (@message) ->
  Error.call(@)
  Error.captureStackTrace(@, arguments.callee)
  @name = arguments.callee?.caller?.name or 'Error'

AbstractError.prototype.__proto__ = Error.prototype

class IllegalArgumentError extends AbstractError

class InvalidTypeError extends AbstractError

class UnknownValueError extends AbstractError

class UndefinedValueError extends AbstractError

# hide this file from the stack trace
{trimStackTrace} = require './error_handler'
trimStackTrace __filename

# export all preconditions
module.exports.checkArgument   = checkArgument
module.exports.checkNumberType = checkNumberType
module.exports.checkContains   = checkContains
module.exports.checkEquals     = checkEquals
module.exports.checkDefined    = checkDefined

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError     = InvalidTypeError
module.exports.InvalidTypeError     = InvalidTypeError
module.exports.UnknownValueError     = UnknownValueError
module.exports.UndefinedValueError  = UndefinedValueError
