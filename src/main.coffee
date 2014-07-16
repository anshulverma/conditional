module.exports.checkArgument = (condition, message) ->
  message ?= 'invalid argument'
  throw new IllegalArgumentError(message) unless condition

module.exports.checkNumberType = (value, message='invalid type') ->
  throw new InvalidTypeError(message) unless isNumeric value

isArray = Array.isArray

# refer to this snippet from jQuery for explanation:
# https://github.com/jquery/jquery/blob/bbdfb/src/core.js#L212
isNumeric = (value) ->
  !isArray(value) && (value - parseFloat(value) + 1) >= 0

AbstractError = (@message) ->
  Error.call(@)
  Error.captureStackTrace(@, arguments.callee)
  @name = arguments.callee?.caller?.name or 'Error'

AbstractError.prototype.__proto__ = Error.prototype

class IllegalArgumentError extends AbstractError
  constructor: (message) ->
    super message

class InvalidTypeError extends AbstractError
  constructor: (message) ->
    super message

# remove unwanted frames from stack trace
prepareStackTrace = Error.prepareStackTrace
Error.prepareStackTrace = (err, stack) ->
  stack.splice(0, 1) while do stack[0].getFileName is __filename
  prepareStackTrace err, stack

module.exports.IllegalArgumentError = IllegalArgumentError
module.exports.InvalidTypeError = InvalidTypeError
