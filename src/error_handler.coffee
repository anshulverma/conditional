# a list of unwanted frames
unwanted = []

# export initialization method
module.exports.trimStackTrace = (file) -> unwanted.push file

module.exports.overrideStack = -> do overrideStack

# override stack to hide certain frames
overrideStack = ->
  # remove unwanted frames from stack trace
  prepareStackTrace = Error.prepareStackTrace
  Error.prepareStackTrace = (err, stack) ->
    stack.splice(0, 1) while do stack[0].getFileName in unwanted
    prepareStackTrace err, stack
do overrideStack
