{checkContains} = require './src/main'

module.exports = (grunt) ->
  grunt.initConfig
    env:
      options:
        concat:
          value: 'node_modules/.bin'
          delimiter: ':'
      dev:
        NODE_ENV: 'development'
      coverage:
        NODE_ENV: 'coverage'
    coffee:
      compile:
        expand: true
        flatten: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'
    mochaTest:
      options:
        require:
          [
            'coffee-script/register',
            'coffee-script',
            'test/test_helper.coffee'
          ]
      test:
        options:
          reporter: 'spec'
          colors: true
        src: [ 'test/*.coffee' ]
      coverageHTML:
        options:
          reporter: 'html-cov'
          captureFile: 'coverage/index.html'
          quiet: true
        src: [ 'test/*.coffee' ]
      coverageLCOV:
        options:
          reporter: 'mocha-lcov-reporter'
          captureFile: 'coverage/lcov.info'
          quiet: true
        src: [ 'test/*.coffee' ]
    coffeelint:
      src:
        files:
          src: [ 'src/*.coffee' ]
      test:
        files:
          src: [ 'test/*.coffee' ]
      buildTools:
        files:
          src: [ 'Gruntfile.coffee' ]
      options:
        configFile: 'coffeelint.json'
    docco:
      all:
        src: [ 'src/*.coffee', 'test/*.coffee']
        options:
          output: 'docs/'
    coffeeCoverage:
      options:
        initFile: 'coverage/src/init.js'
        path: 'relative'
      all:
        src: 'src'
        dest: 'coverage/src'
    coveralls:
      coverage:
        src: 'coverage/lcov.info'
        force: true
    sed:
      lcov:
        path: 'coverage/lcov.info'
        pattern: 'SF:'
        replacement: 'SF:src/'
    clean:
      coverage: 'coverage'
      docs: 'docs'
      lib: 'lib'

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-coffee-coverage'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coveralls'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-sed'

  buildType = grunt.option('type') || 'local'
  checkContains buildType, ['local', 'ci'], "invalid build type '#{buildType}'"

  switch buildType
    when 'local'
      grunt.registerTask '_coverage', ['mochaTest:coverageHTML']
    when 'ci'
      grunt.registerTask '_coverage',
        [
          'mochaTest:coverageLCOV',
          'sed:lcov',
          'coveralls:coverage'
        ]

  grunt.registerTask 'coverage',
    [
      'env:coverage',
      'clean:coverage',
      'coffeeCoverage',
      '_coverage'
    ]
  grunt.registerTask 'docs',    ['clean:docs', 'docco']
  grunt.registerTask 'test',    ['mochaTest:test']
  grunt.registerTask 'default', ['test']
  grunt.registerTask 'build',
    [
      'clean',
      'coffeelint',
      'test',
      'coffee:compile',
      'docs'
    ]
