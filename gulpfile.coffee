APINAME = 'ga'

{full: version} = require './lib/version'
BASENAME = "#{APINAME}-#{version}"
isDevelopment = version.indexOf('SNAPSHOT') > 0

gulp = require 'gulp'
util = require 'gulp-util'

gulp.task 'default', ['compress']


mocha = require 'gulp-mocha'
gulp.task 'test', ->
  gulp.src ['test/**/*.coffee']
    .pipe mocha
      reporter: 'spec'
    .on 'error', (error)->
      util.log error
      @emit 'end'


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
  gulp.watch 'test/*.coffee', ['test']
  gulp.watch 'lib/*.coffee', ['compress']


gulp.task 'server', ['watch'], ->
  app = require './app'
  app.set 'port', process.env.PORT || 3000
  server = app.listen app.get('port'), ->
    console.log 'Express server listening on port ' + server.address().port
