{full: version} = require './lib/version'

express = require 'express'
app = express()

logger = require 'morgan'
app.use logger 'dev'

basedir = "#{__dirname}/samples"
cachedir = "#{__dirname}/.cache"

# view engine setup
app.set 'views', "#{basedir}"
app.set 'view engine', 'jade'

compression = require 'compression'
app.use compression
  debug: true

app.use express.static "#{basedir}"
app.use express.static "#{__dirname}/."

stylus = require 'stylus'
app.use stylus.middleware
  src: "#{basedir}"
  dest: cachedir
  debug: true

coffee = require 'coffee-middleware'
app.use coffee
  src: "#{basedir}"
  debug: true

app.use express.static cachedir

app.get '/ga.js', (req, res) ->
  res.redirect "ga-#{version}.js"

app.get '/ga.min.js', (req, res) ->
  res.redirect "ga-#{version}.min.js"

app.get '/*', (req, res) ->
  res.render req.params[0]

module.exports = app
