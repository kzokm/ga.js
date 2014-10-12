APINAME = 'ga'

{full: version} = require './lib/version'
BASENAME = "#{APINAME}-#{version}"
isDevelopment = version.indexOf('SNAPSHOT') > 0

gulp = require 'gulp'
browserify = require 'browserify'
exorcist = require 'exorcist'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
fs = require 'fs'

gulp.task 'default', ['compress']

gulp.task 'browserify', ->
  b = browserify
    extensions: ['.coffee']
    debug: isDevelopment
  .add './browser/entry.coffee'
  .transform 'coffeeify'
  .bundle (error)->
    if error
      console.error error
      b.end()
  .pipe exorcist "#{BASENAME}.js.map"
  .pipe fs.createWriteStream "#{BASENAME}.js"

gulp.task 'compress', ['browserify'], ->
  gulp.src "#{BASENAME}.js"
  .pipe uglify
    outSourceMap: true
  .pipe concat "#{BASENAME}.min.js"
  .pipe gulp.dest '.'

gulp.task 'watch', ['compress'], ->
  gulp.watch 'lib/*.coffee', ['compress']

gulp.task 'server', ['watch'], ->
  app = require './app'
  app.set 'port', process.env.PORT || 3000
  server = app.listen app.get('port'), ->
    console.log 'Express server listening on port ' + server.address().port
