require 'coffee-script/register'
gulp = require 'gulp'

Server = require('karma').Server
pug = require 'gulp-pug'
stylus = require 'gulp-stylus'
coffee = require 'gulp-coffee'
wrap = require 'gulp-wrap'
del = require('del')

finalhandler = require('finalhandler')
http = require('http')
serveStatic = require('serve-static')

wrapTemplate = """
        (function(window){\n"use strict";\n<%= contents %>\n})(window);
    """

gulp.task 'demo:clean', -> del([
    'demo/**/*.html'
    'demo/**/*.js'
    'demo/**/*.css'
])

gulp.task 'dist:clean', -> del(['dist/**/*'])

gulp.task 'demo:pug', ['demo:clean'], ->
    gulp.src('./demo/index.pug')
        .pipe(pug())
        .pipe(gulp.dest('./demo'))

gulp.task 'demo:coffee', ['demo:clean'], ->
    gulp.src('demo/main.coffee')
        .pipe(coffee bare: true)
        .pipe(wrap(wrapTemplate))
        .pipe(gulp.dest 'demo/')

gulp.task 'demo:stylus', ['demo:clean'], ->
    gulp.src('./demo/**/*.styl')
        .pipe(stylus())
        .pipe(gulp.dest('./demo'))

gulp.task 'demo:copy', ['demo:clean', 'default'], ->
    gulp.src([
        "node_modules/d3/*d3*.js"
        "dist/**/*"
    ]).pipe(gulp.dest('demo'))

gulp.task 'demo', [
    'default'
    'demo:pug'
    'demo:coffee'
    'demo:stylus'
    'demo:copy'
]

gulp.task 'chart:stylus', ['dist:clean'], ->
    gulp.src('./src/**/*.styl')
    .pipe(stylus())
    .pipe(gulp.dest('dist'))

gulp.task 'chart:coffee', ['dist:clean'], ->
    gulp.src('src/matrix.coffee')
    .pipe(coffee bare: true)
    .pipe(wrap(wrapTemplate))
    .pipe(gulp.dest 'dist')


gulp.task 'default', [
    'dist:clean'
    'chart:stylus'
    'chart:coffee'
]

gulp.task 'watch', ->
    watchFiles = [
        './src/**/*.coffee',
        './src/**/*.styl',
        './src/**/*.pug'
        './demo/**/*.styl'
        './demo/**/*.pug'
        './demo/**/*.coffee'
    ]
    gulp.watch watchFiles, ['demo']

gulp.task 'serve', ->
    serve = serveStatic 'demo'
    server = http.createServer (req, res) ->
        serve(req, res, finalhandler(req, res))
    server.listen 1024
    console.log 'A simple webserver started: localhost:1024'

gulp.task 'test', ['default'], (done) ->

    files = [
        "node_modules/d3/d3.min.js"
        "src/*.coffee"
        "demo/*.coffee"
    ]

    options =
        logLevel: 'INFO'
        browsers: ['Firefox']
        frameworks: [ 'mocha', 'sinon-chai' ]
        reporters: [ 'spec', 'junit', 'coverage' ]
        singleRun: true
        preprocessors:
            'src/**/*.coffee': ['coffee', 'coverage']
            'demo/**/*.coffee': ['coffee', 'coverage']
            'demo/**/*.pug': ['pug', 'ng-html2js']
        files: files
        junitReporter:
            outputDir: 'demo/reports'
            outputFile: 'karma.xml'
        coverageReporter:
            type: 'lcov'
            dir: 'demo/coverage/'

    new Server(options, done).start()