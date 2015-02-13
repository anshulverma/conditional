# We need to execute annotated source for coverage report generation. This can
# be determined using `NODE_ENV`.
coverageMode = process.env['NODE_ENV'] is 'coverage'
srcPath = if coverageMode then '../../coverage/src' else '../../src'
srcType = if coverageMode then 'js' else 'coffee'

global.preconditions = require "#{srcPath}/main"

# Somehow `Error.prepareStackTrace` gets overridden when running tests using
# grunt's mocha task. This is why we have to override stackTrace again here.
{overrideStack} = require "#{srcPath}/error_handler"
do overrideStack
