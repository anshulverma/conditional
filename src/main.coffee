module.exports.checkArgument = (condition, message) ->
  message ?= 'invalid argument'
  throw new IllegalArgumentError(message) unless condition

AbstractError = (@message) ->
  Error.call(@)
  Error.captureStackTrace(@, arguments.callee)
  @name = arguments.callee?.caller?.name or 'Error'

AbstractError.prototype.__proto__ = Error.prototype

class IllegalArgumentError extends AbstractError
  constructor: (message) ->
    super message

# remove unwanted frames from stack trace
prepareStackTrace = Error.prepareStackTrace
Error.prepareStackTrace = (err, stack) ->
  stack.splice(0, 1) while do stack[0].getFileName is __filename
  prepareStackTrace err, stack
