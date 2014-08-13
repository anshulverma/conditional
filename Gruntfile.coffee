{checkContains} = require './src/main'

module.exports = (grunt) ->
  grunt.initConfig
    env:
      options:
        PATH:
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
        cwd: '<%= path.src %>'
        src: ['*.coffee']
        dest: '<%= path.build %>'
        ext: '.js'
    watch:
      coffee:
        files: ['<%= path.src %>/*.coffee', '<%= path.test %>/*.coffee']
        tasks: 'build'
        options:
          spawn: false
    mochaTest:
      options:
        require:
          [
            'coffee-script/register',
            'coffee-script',
            '<%= path.test %>/test_helper.coffee'
          ]
      test:
        options:
          reporter: 'spec'
          colors: true
        src: [ '<%= path.test %>/*.coffee' ]
      coverageHTML:
        options:
          reporter: 'html-cov'
          captureFile: '<%= path.coverage %>/index.html'
          quiet: true
        src: [ '<%= path.test %>/*.coffee' ]
      coverageLCOV:
        options:
          reporter: 'mocha-lcov-reporter'
          captureFile: '<%= path.coverage %>/lcov.info'
          quiet: true
        src: [ '<%= path.test %>/*.coffee' ]
    coffeelint:
      src:
        files:
          src: [ '<%= path.src %>/*.coffee' ]
      test:
        files:
          src: [ '<%= path.test %>/*.coffee' ]
      buildTools:
        files:
          src: [ 'Gruntfile.coffee' ]
      options:
        configFile: 'coffeelint.json'
    docco:
      all:
        src: [ '<%= path.src %>/*.coffee', '<%= path.test %>/*.coffee']
        options:
          output: 'docs/'
    coffeeCoverage:
      options:
        initFile: '<%= path.coverage %>/src/init.js'
        path: 'relative'
      all:
        src: '<%= path.src %>'
        dest: '<%= path.coverage %>/src'
    coveralls:
      coverage:
        src: '<%= path.coverage %>/lcov.info'
        force: true
    sed:
      lcov:
        path: '<%= path.coverage %>/lcov.info'
        pattern: 'SF:'
        replacement: 'SF:<%= path.src %>/'
    clean:
      coverage: '<%= path.coverage %>'
      docs: 'docs'
      build: '<%= path.build %>'
    path:
      src: 'src'
      test: 'test'
      build: 'lib'
      coverage: 'coverage'

  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-coffee-coverage'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coveralls'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-sed'
  grunt.loadNpmTasks 'grunt-contrib-watch'

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
