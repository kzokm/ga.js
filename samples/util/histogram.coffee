class @Histogram extends DrawingArea
  constructor: (element, @config = {})->
    super
    @chart = @svg.append 'g'
      .attr
        class: 'histogram'
    @viewBox.update
      width: @config.resolution ?= 200
      height: 100
      preserveAspectRatio: 'none'
    @scale =
      x: 1
      y: 1

  setup: (range, value)->
    [@min, @max] = range
    @scale.x = @viewBox.width / (@max - @min)
    @histogram = d3.layout.histogram()
      .range range
      .bins d3.range @min, @max, (@max - @min) / @config.resolution
      .value value

  update: (popuration)->
    @chart.selectAll 'rect'
      .remove()
    @chart.selectAll 'rect'
      .data @histogram popuration.individuals
      .enter()
      .append 'rect'
      .attr
        x: (d)=> (d.x - @min) * @scale.x
        y: (d)=> (@viewBox.height - d.y) * @scale.y
        width: (d)=> d.dx * @scale.x
        height: (d)=> d.y * @scale.y
