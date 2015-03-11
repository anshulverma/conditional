try
  debug = require('debug') 'conditional'
catch e
  debug =
    (message) ->
      console.log "#{name} :: #{message}"

module.exports = debug
