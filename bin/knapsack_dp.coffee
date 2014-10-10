#!env coffee

{argv} = process
path = require 'path'

if argv.length < 4
  console.error "Usase: #{path.basename argv[1]} capacity items.json"

capacity = argv[2]
{items, params} = require "#{process.cwd()}/#{argv[3]}"

WEIGHT_UNIT = 1 / params.weight.unit
PRICE_UNIT = 1 / params.price.unit

items.forEach (e)->
  e.weight *= WEIGHT_UNIT
  e.price *= PRICE_UNIT

m = [[]]
for j in [0..capacity * WEIGHT_UNIT]
  m[0].push
    weight: 0
    price: 0
    items: []

for i in [1..items.length]
  m.push []
  for j in [0..capacity * WEIGHT_UNIT]
    {weight: c, price: p} = items[i - 1]
    m[i][j] =
      if c <= j and (m[i - 1][j - c].price + p >= m[i - 1][j].price)
        prev = m[i - 1][j - c]
        weight: prev.weight + c
        price: prev.price + p
        items: prev.items.concat i
      else
        m[i - 1][j]

result = m[items.length][capacity * WEIGHT_UNIT]
result.weight /= WEIGHT_UNIT
result.price /= PRICE_UNIT
console.log result.items
console.log "$#{result.price.toFixed 2}, #{result.weight.toFixed 1}Kg of #{result.items.length}"
