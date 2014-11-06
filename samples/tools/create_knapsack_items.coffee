#!env coffee

WEIGHT_UNIT = 10
PRICE_UNIT = 100

{argv} = process
argv.shift()
argv.shift()

size = argv.shift()
unless size
  path = require 'path'
  console.error "Usase: #{path.basename argv[1]} numberOfItems minWeight maxWeight"
  return -1

min = parseFloat argv.shift() ? 0.5
max = parseFloat argv.shift() ? min * 10

random = (max)->
  1 + Math.floor Math.random() * max

items = []
for i in [1..size]
  weight = random((max - min) * WEIGHT_UNIT) / WEIGHT_UNIT + min
  price = Math.round(random(100) / 50 * weight * PRICE_UNIT) / PRICE_UNIT
  items.push
    name: "item-#{i}"
    weight: weight
    price: price

json = JSON.stringify
  params:
    weight:
      min: min
      max: max
      unit: 1 / WEIGHT_UNIT
    price:
      unit: 1 / PRICE_UNIT
  items: items
.replace /},/g, "},\n"

console.log json
