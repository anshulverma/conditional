describe 'Preconditions', ->
  describe '#arguments', ->
    it '#simple', ->
      preconditions.arg false, 'this must fail'
