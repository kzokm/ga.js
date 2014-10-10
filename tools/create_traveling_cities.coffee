#!env coffee

{argv} = process
path = require 'path'

size = argv[2]
unless size
  console.error "Usase: #{path.basename argv[1]} numberOfCities"

random = (max)->
  Math.floor Math.random() * max

POSITION_UNIT = 10

cities = []
for i in [1..size]
  cities.push
    name: "city-#{i}"
    x: random(1000) / 10
    y: random(1000) / 10

json = JSON.stringify
  params:
    position:
      min: 0.0
      max: 100.0
      unit: 0.1
  cities: cities
.replace /},/g, "},\n"

console.log json
