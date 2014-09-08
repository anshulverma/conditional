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

isBoolean = (value) ->
  typeof value is 'boolean'

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
        return false unless isEqual(actual[i], expected[i]) and
                            isNotUndefined actual[i]
    when isObject expected
      for key, value of expected
        return false unless isEqual actual[key], value
    when actual isnt expected then return false
  true

isPrimitive = (value) ->
  isNumeric(value) or isBoolean(value)

# hide this file from the stack trace
{trimStackTrace} = require './error_handler'
trimStackTrace __filename

xor = (operand1, operand2) ->
  !operand1 != !operand2

# export all utility methods
module.exports.negate           = negate

module.exports.isObject         = isObject

module.exports.isArray          = isArray
module.exports.isNotArray       = isNotArray

module.exports.isNumeric        = isNumeric

module.exports.isString         = isString

module.exports.isEmptyString    = isEmptyString

module.exports.isUndefined      = isUndefined
module.exports.isNotUndefined   = isNotUndefined

module.exports.isEqual          = isEqual

module.exports.isPrimitive      = isPrimitive
module.exports.isNotPrimitive   = negate isPrimitive

module.exports.xor              = xor
