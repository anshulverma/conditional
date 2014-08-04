{trimStackTrace} = require './error_handler'
{
  isObject
  isArray, isNotArray
  isNumeric
  isString
  isEmptyString
  isNotUndefined
} = require './util'

checkArgument = (condition, message) ->
  message ?= 'invalid argument'
  throw new IllegalArgumentError(message) unless isString(condition) or
                                                 isNumeric(condition) or
                                                 condition

checkNumberType = (value, message='invalid type') ->
  throw new InvalidTypeError(message) unless isNumeric value

checkContains = (value, object, message="unknown value '#{value}'") ->
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
    when isNumeric object
      do invokeError unless ~object.toString().indexOf value
    else do invokeError unless value of object

checkEquals = (actual,
               expected,
               message="expected '#{expected}' but got '#{actual}'") ->
  checkArgument isNotUndefined(expected), 'invalid value expected'

  invokeError = ->
    throw new UnknownValueError(message)

  switch
    when isArray expected
      do invokeError if isNotArray(actual) or actual.length isnt expected.length
      for i in [0...expected.length]
        do invokeError unless (actual[i] is expected[i] and isNotUndefined actual[i])
    when isObject expected
      actual[key] is value or do invokeError for key, value of expected
    when actual isnt expected then do invokeError

AbstractError = (@message) ->
  Error.call(@)
  Error.captureStackTrace(@, arguments.callee)
  @name = arguments.callee?.caller?.name or 'Error'

AbstractError.prototype.__proto__ = Error.prototype

class IllegalArgumentError extends AbstractError

class InvalidTypeError extends AbstractError

class UnknownValueError extends AbstractError

# hide this file from the stack trace
trimStackTrace __filename

# export all preconditions
module.exports.checkArgument = checkArgument
module.exports.checkNumberType = checkNumberType
module.exports.checkContains = checkContains
module.exports.checkEquals = checkEquals

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError = InvalidTypeError
module.exports.UnknownValueError = UnknownValueError
