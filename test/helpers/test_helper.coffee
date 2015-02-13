global.assert = require('chai').assert

if window?
  require './browser_helper'
else
  require './node_helper'
