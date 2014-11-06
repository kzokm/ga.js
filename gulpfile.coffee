APINAME = 'ga'

{full: version} = require './lib/version'
BASENAME = "#{APINAME}-#{version}"
isDevelopment = version.indexOf('SNAPSHOT') > 0

gulp = require 'gulp'
util = require 'gulp-util'

gulp.task 'default', ['compress']


mocha = require 'gulp-mocha'
test = (src)->
  console.log 'test', arguments
  gulp.src src
    .pipe mocha
      reporter: 'spec'
    .on 'error', (error)->
      util.log error
      @emit 'end'

gulp.task 'test', ->
  test 'test/**/*.coffee'

gulp.task 'samples:test', ->
  test 'samples/test/**/*.coffee'

browserify = require 'browserify'
exorcist = require 'exorcist'
fs = require 'fs'

gulp.task 'browserify', ['test'], ->
  browserify
    extensions: ['.coffee']
    debug: isDevelopment
  .add './browser/entry.coffee'
  .transform 'coffeeify'
  .bundle (error)->
    if error
      util.log error
      @emit 'end'
  .pipe exorcist "#{BASENAME}.js.map"
  .pipe fs.createWriteStream "#{BASENAME}.js"


uglify = require 'gulp-uglify'
concat = require 'gulp-concat'

gulp.task 'compress', ['browserify'], ->
  gulp.src "#{BASENAME}.js"
  .pipe uglify
    outSourceMap: true
  .pipe concat "#{BASENAME}.min.js"
  .pipe gulp.dest '.'


gulp.task 'watch', ['compress'], ->
  gulp.watch 'lib/*.coffee', ['compress']
  gulp.watch 'test/lib/*.coffee', ['test']
  gulp.watch 'test/*.coffee', (e)->
    test e.path unless e.type == 'deleted'

gulp.task 'samples:watch', ['watch', 'samples:test'], ->
  gulp.watch 'lib/*.coffee', ['samples:test']
  gulp.watch 'samples/test/*.coffee', (e)->
    unless e.type == 'deleted'
      src = e.path.replace /\\/g, '/'
      test src
  gulp.watch 'samples/*.coffee', (e)->
    unless e.type == 'deleted'
      src = e.path.replace /\\/g, '/'
        .replace /([a-z]*).coffee/, 'test/$1_test.coffee'
      test src

gulp.task 'server', ['samples:watch'], ->
  app = require './samples/server'
  app.set 'port', process.env.PORT || 3000
  server = app.listen app.get('port'), ->
    console.log 'Express server listening on port ' + server.address().port
