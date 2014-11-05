{full: version} = require '../lib/version'

express = require 'express'
app = express()

logger = require 'morgan'
app.use logger 'dev'

cachedir = "#{__dirname}/.cache"

# view engine setup
app.set 'views', "#{__dirname}/."
app.set 'view engine', 'jade'

compression = require 'compression'
app.use compression
  debug: true

app.use express.static "#{__dirname}/."

stylus = require 'stylus'
app.use stylus.middleware
  src: "#{__dirname}/layouts"
  dest: cachedir
  debug: true

coffee = require 'coffee-middleware'
app.use coffee
  src: "#{__dirname}"
  debug: true

app.use express.static cachedir

app.get '/ga.js', (req, res) ->
  res.sendFile "ga-#{version}.js",
    root: "${__dirname}/.."

app.get '/ga.min.js', (req, res) ->
  res.sendFile "ga-#{version}.min.js",
    root: "${__dirname}/.."

app.get '/*', (req, res) ->
  res.render req.params[0]

module.exports = app
