negate = (fn) ->
  (value) ->
    not fn value

isObject = (value) ->
  value? and typeof value is 'object'

isArray = Array.isArray

isNotArray = negate isArray

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
  isString(value) and not value

isUndefined = (value) ->
  typeof value is 'undefined'

isNotUndefined = negate isUndefined

isEqual = (actual, expected) ->
  switch
    when isArray expected
      return false if isNotArray(actual) or actual.length isnt expected.length
      for i in [0...expected.length]
        return false unless isEqual(actual[i], expected[i]) and isNotUndefined actual[i]
    when isObject expected
      for key, value of expected
        return false unless isEqual actual[key], value
    when actual isnt expected then return false
  true

# throw error in a check by default
DEFAULT_CALLBACK = (err) ->
  throw err if err?

# Wrap check function to properly assign defaults for `message` and `callback`
precondition = (check, defaultMessage, argc) ->
  ->
    args = []
    message = arguments[argc] || defaultMessage
    callback = arguments[argc + 1] || DEFAULT_CALLBACK
    if typeof message is 'function'
      callback = message
      message = defaultMessage
    Array::push.call args, arg for arg in Array::splice.call arguments, 0, argc
    Array::push.call args, message
    try
      check.apply @, args
      callback null
    catch e
      callback e

# hide this file from the stack trace
{trimStackTrace} = require './error_handler'
trimStackTrace __filename

# export all utility methods
module.exports.isObject         = isObject

module.exports.isArray          = isArray
module.exports.isNotArray       = isNotArray

module.exports.isNumeric        = isNumeric

module.exports.isString         = isString

module.exports.isEmptyString    = isEmptyString

module.exports.isUndefined      = isUndefined
module.exports.isNotUndefined   = isNotUndefined

module.exports.isEqual          = isEqual

module.exports.precondition     = precondition
