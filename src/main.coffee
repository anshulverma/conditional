{trimStackTrace} = require './error_handler'

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

isArray = Array.isArray

# refer to this snippet from jQuery for explanation:
# https://github.com/jquery/jquery/blob/bbdfb/src/core.js#L212
isNumeric = (value) ->
  !isArray(value) && (value - parseFloat(value) + 1) >= 0

toString = Object.prototype.toString

# refer to underscore.js for explanation
# http://underscorejs.org/docs/underscore.html#section-107
isString = (value) ->
  toString.call(value) is '[object String]'

isEmptyString = (value) ->
  checkArgument isString(value), 'value must be a string'
  not value

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

# export error types
module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError = InvalidTypeError
module.exports.UnknownValueError = UnknownValueError
