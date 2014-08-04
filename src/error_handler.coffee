# remove unwanted frames from stack trace
trimStackTrace = (file) ->
  prepareStackTrace = Error.prepareStackTrace
  Error.prepareStackTrace = (err, stack) ->
    stack.splice(0, 1) while do stack[0].getFileName is file
    prepareStackTrace err, stack

# export initialization method
module.exports.trimStackTrace = trimStackTrace
