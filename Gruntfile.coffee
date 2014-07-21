module.exports = (grunt) ->
  grunt.initConfig {
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
    mochacov: {
      options: {
        coveralls: true
        files: 'test/*.coffee'
      }
    }
  }

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-blanket'
  grunt.loadNpmTasks 'grunt-mocha-cov'

  grunt.registerTask 'default', ['mochaTest', 'coffeelint']
  grunt.registerTask 'travis', ['default', 'mochacov']
