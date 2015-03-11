# We need to execute annotated source for coverage report generation. This can
# be determined using `NODE_ENV`.
coverageMode = process.env['NODE_ENV'] is 'coverage'
srcPath = if coverageMode then '../../coverage/src' else '../../src'
srcType = if coverageMode then 'js' else 'coffee'

global.preconditions = require "#{srcPath}/main"
