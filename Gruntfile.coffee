module.exports = (grunt) ->
  grunt.initConfig {
    coffee: {
      compile: {
        options: {
          bare: true
        }
        files: {
          'lib/main.js': 'src/main.coffee'
        }
      }
    }
    mochaTest: {
      test: {
        options: {
          reporter: 'spec'
          colors: true
          require: [
            'coffee-script'
            'coffee-script/register'
            'test/test_helper.coffee'
          ]
        }
        src: [ 'test/*.coffee' ]
      }
    }
    coffeelint: {
      src: {
        files: {
          src: [ 'src/*.coffee' ]
        }
      }
      test: {
        files: {
          src: [ 'test/*.coffee' ]
        }
      }
      buildTools: {
        files: {
          src: [ 'Gruntfile.coffee' ]
        }
      }
      options: {
        configFile: 'coffeelint.json'
      }
    }
    blanket: {
      options: {
        pattern: 'src'
        loader: './node-loaders/coffee-script'
      }
      files: {
        'coverage/': [ 'src/' ]
      }
    }
    docco: {
      debug: {
        src: [ 'src/*.coffee', 'test/*.coffee']
        options: {
          output: 'docs/'
        }
      }
    }
    mochacov: {
      coverage: {
        options: {
          coveralls: true
        }
      }
      options: {
        files: 'test/*.coffee'
      }
    }
  }

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-blanket'
  grunt.loadNpmTasks 'grunt-mocha-cov'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-docco'

  grunt.registerTask 'docs', ['docco']
  grunt.registerTask 'default', ['mochaTest', 'coffeelint', 'coffee', 'docs']
  grunt.registerTask 'travis', ['default', 'mochacov']
  grunt.registerTask 'test', ['mochaTest', 'coffeelint']
