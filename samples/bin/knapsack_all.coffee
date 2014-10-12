#!env coffee

{argv} = process

if argv.length < 4
  path = require 'path'
  console.error "Usase: #{path.basename argv[1]} capacity items.json"

capacity = parseFloat argv[2]
{items} = require "#{process.cwd()}/#{argv[3]}"

console.info "number of items: #{items.length}"
console.info "capacity: #{capacity.toFixed 1}Kg"

class Knapsack
  constructor: (source = {})->
    @weight = source.weight ? 0
    @price = source.price ? 0
    @items = source.items ? []

  add: (i)->
    {weight, price} = items[i - 1]
    if @weight + weight <= capacity
      new Knapsack
        weight: @weight + weight
        price: @price + price
        items: @items.concat i

  resolv: (i = 1)->
    if i < items.length
      max @, max @resolv(i + 1), @add(i)?.resolv(i + 1)
    else
      max @, @add(i)

max = (m1, m2)->
  return m1 unless m2?
  if m1.price >= m2.price then m1 else m2

result = new Knapsack().resolv()
console.info 'uptime: ' + process.uptime()
console.info 'result: ' + result.items
console.log "amount prices: $#{result.price.toFixed 2}, weight: #{result.weight.toFixed 1}Kg of #{result.items.length}"
