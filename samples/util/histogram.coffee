class @Histogram
  constructor: (element)->
    @svg = d3.select element

    $(window).on 'resize', =>
      @resize()
    @resize()

  container = $('#container')[0]

  resize: ->
    @svg.attr
      width: @width = window.innerWidth - @svg[0][0].offsetLeft * 2
      height: @height = window.innerHeight - container.offsetTop * 2 - @svg[0][0].offsetTop
    @scale =
      x: @width / (@max - @min)
      y: 5

  setup: (range, value)->
    [@min, @max] = range
    @histogram = d3.layout.histogram()
      .range range
      .bins d3.range @min, @max, (@max - @min) / 200
      .value value
    @resize()

  update: (popuration)->
    @svg.selectAll 'rect'
      .remove()
    @svg.selectAll 'rect'
      .data @histogram popuration.individuals
      .enter()
      .append 'rect'
      .attr
        x: (d)=> (d.x - @min) * @scale.x
        y: (d)=> @height - d.y * @scale.y
        width: (d)=> d.dx * @scale.x
        height: (d)=> d.y * @scale.y
        fill: '#888'
