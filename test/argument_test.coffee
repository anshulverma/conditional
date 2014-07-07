describe 'Preconditions', ->
  describe '#arguments', ->
    it '#simple', ->
      try
        preconditions.arg false, 'this must fail'
      catch e then console.log e.stack
      assert.fail 'precondition arg check should fail for false condition'
