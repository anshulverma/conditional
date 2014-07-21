module.exports = (grunt) ->
  grunt.initConfig {
    coffee: {
      compile: {
        options: {
          bare: true
        }
        files: {
          'src/main.js': 'src/main.coffee'
          'test/js/argument_test.js': 'test/argument_test.coffee'
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
    mocha_istanbul: {
      coveralls: {
        src: 'test'
        options: {
          coverage: true
          check: {
            lines: 90
            statements: 90
            funtions: 90
          }
          root: './src'
          reportFormats: ['lcovonly', 'html']
        }
      }
    }
  }

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-blanket'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-mocha-istanbul'

  grunt.registerTask 'docs', ['docco']
  grunt.registerTask 'coveralls', ['mocha_istanbul:coveralls']
  grunt.registerTask 'test', ['coffeelint', 'coffee', 'coveralls']
  grunt.registerTask 'default', ['test', 'docs']
  grunt.registerTask 'travis', ['default', 'mochacov']

  grunt.event.on 'coverage', (lcov, done) ->
    do done
