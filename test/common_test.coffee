{checkArgument, checkNumberType} = require '../src/main'

FORCED_ERROR = 'this must fail'

executors = [
  {
    name: 'argument check'
    execute: -> checkArgument false, FORCED_ERROR
  }
  {
    name: 'type check'
    execute: -> checkNumberType 'string', FORCED_ERROR
  }
]

describe 'common tests for preconditions', ->
  describe 'error trace should not contain unwanted frames', ->
    for executor in executors
      it "#{executor.name}", do (executor) ->
        ->
          try
            do executor.execute
            assert.fail "precondition #{executor.name} should fail"
          catch e
            assert.equal e.message, FORCED_ERROR,
              "error message should be '#{FORCED_ERROR}'"
            assert.notInclude e.stack, 'main.coffee',
              'stack trace should not contain unwanted frames'
