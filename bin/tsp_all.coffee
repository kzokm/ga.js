#!env coffee
{argv} = process
if argv.length < 3
  path = require 'path'
  console.error "Usase: #{path.basename argv[1]} cities.json"

{cities, params} = require "#{process.cwd()}/#{argv[2]}"
numCities = cities.length
console.info 'number of cities: ' + numCities

resolv = (route)->
  if route.length == numCities
    evaluate route
  else
    for p in [1..numCities - 1]
      unless route.indexOf(p) >= 0
        if route.length < numCities - 1 or route[1] < p
          d = route.distance + distance route[route.length - 1], p
          if d < result.distance
            next = route.concat p
            next.distance = d
            resolv next
  undefined

result = { distance: Number.MAX_VALUE }
evaluate = (route)->
  route.distance += distance route[0], route[route.length - 1]
  if route.distance < result.distance
    result = route

distance = (i, j)->
  c1 = cities[i]
  c2 = cities[j]
  Math.sqrt Math.pow(c1.x - c2.x, 2) + Math.pow(c1.y - c2.y, 2)


for i in [1..numCities - 2]
  route = [0, i]
  route.distance = distance 0, i
  resolv route

console.info 'uptime: ' + process.uptime()
console.info 'result: ' + result.slice()
console.info 'distance: '+ result.distance.toFixed 3
