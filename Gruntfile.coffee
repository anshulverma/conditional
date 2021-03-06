{checkContains} = require './src/main'
pkg = require './package.json'

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
      debug:
        DEBUG: grunt.option 'dbg'
    coffee:
      src:
        cwd: '<%= path.src %>'
        src: [ '*.coffee' ]
        dest: '<%= path.build %>/src'
        ext: '.js'
        expand: true
        flatten: true
      testSrc:
        cwd: '<%= path.test %>'
        src: [ '*.coffee' ]
        dest: '<%= path.build %>/test'
        ext: '.js'
        expand: true
        flatten: true
      testHelpers:
        cwd: '<%= path.test %>/helpers'
        src: [ '*.coffee' ]
        dest: '<%= path.build %>/test/helpers'
        ext: '.js'
        expand: true
        flatten: true
    browserify:
      options:
        banner: '// CommonJS export for browser - please do not edit directly'
        external: [ 'debug', 'ms' ]
        browserifyOptions:
          standalone: 'preconditions'
          transform: 'browserify-shim'
      src:
        src: [ '<%= path.build %>/src/main.js' ]
        dest: 'dist/preconditions.js'
      test:
        src: [ '<%= path.build %>/test/*.js' ]
        dest: 'dist/preconditions_test.js'
    uglify:
      options:
        banner: """
                // Preconditions (version #{pkg.version})
                // https://github.com/anshulverma/conditional
                // License MIT
                // Copyright 2014 Anshul Verma

                """
      minify:
        files: 'dist/preconditions.min.js': ['dist/preconditions.js']
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
            'coffee-script'
          ]
      test:
        options:
          reporter: 'hierarchical-reporter'
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
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

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
  grunt.registerTask 'test',    ['env:debug', 'mochaTest:test']
  grunt.registerTask 'default', ['test']
  grunt.registerTask 'build',
    [
      'clean',
      'coffeelint',
      'test',
      'coffee',
      'browserify',
      'uglify',
      'docs'
    ]
