# a list of unwanted frames
unwanted = []

# override stack to hide certain frames
overrideStack = ->
  return if window? # not hiding stack trace in the browser

  # remove unwanted frames from stack trace
  prepareStackTrace = Error.prepareStackTrace
  Error.prepareStackTrace = (err, stack) ->
    stack.splice(0, 1) while do stack[0].getFileName in unwanted
    prepareStackTrace err, stack

# this should be sufficient in non-test environment
do overrideStack

module.exports.trimStackTrace = (file) -> unwanted.push file
module.exports.overrideStack = -> do overrideStack
