negate = (fn) ->
  (value) ->
    not fn value

isObject = (value) ->
  value? and typeof value is 'object'

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
  isString(value) and not value

isUndefined = (value) ->
  typeof value is 'undefined'

# export all utility methods
module.exports.isObject         = isObject

module.exports.isArray          = isArray
module.exports.isNotArray       = negate isArray

module.exports.isNumeric        = isNumeric

module.exports.isString         = isString

module.exports.isEmptyString    = isEmptyString

module.exports.isUndefined      = isUndefined
module.exports.isNotUndefined   = negate isUndefined
