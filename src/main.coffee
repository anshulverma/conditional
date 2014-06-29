modules.exports.arg = (condition, message) ->
  message ?= 'invalid argument'
  throw new IllegalArgumentError(message) if condition

class IllegalArgumentError extends Error
  @constructor -> (@message)
