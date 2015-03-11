try
  debug = require('debug')
catch e
  debug =
    (name) ->
      (message) ->
        console.log "#{name} :: #{message}"

module.exports = debug 'conditional'
