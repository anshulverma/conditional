fs = require 'fs'
{print} = require 'util'
{spawn, exec} = require 'child_process'

bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

walk = (dir, done) ->
  results = []
  fs.readdir dir, (err, list) ->
    return done(err, []) if err
    pending = list.length
    return done(null, results) unless pending
    for name in list
      file = "#{dir}/#{name}"
      try
        stat = fs.statSync file
      catch err
        stat = null
      if stat?.isDirectory()
        walk file, (err, res) ->
          results.push name for name in res
          done(null, results) unless --pending
      else
        results.push file
        done(null, results) unless --pending

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

launch = (cmd, options=[], callback) ->
  app = spawn cmd, options
  app.stdout.pipe(process.stdout)
  app.stderr.pipe(process.stderr)
  app.on 'exit', (status) -> callback?() if status is 0

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false

  options = ['-c', '-b', '-o', 'lib', 'src']
  options.unshift '-w' if watch
  launch 'coffee', options, callback

mocha = (callback) ->
  process.env['NODE_ENV'] = 'test'
  options = [
      '--compilers', 'coffee:coffee-script/register',
      '--reporter', "spec",
      '--require', 'coffee-script',
      '--require', 'test/test_helper.coffee',
      '--colors',
      'test'
    ]
  launch 'mocha', options, callback

docco = (callback) ->
  walk 'src', (err, files) -> launch 'docco', files, callback

task 'docs', 'generate documentation', -> docco -> log 'documentation generation complete', green

task 'build', 'compile source', -> mocha -> build -> log 'build complete', green

task 'watch', 'compile and watch', -> build true, -> log ":-)", green

task 'test', 'run tests', -> mocha -> log "tests finished successfully", bold
