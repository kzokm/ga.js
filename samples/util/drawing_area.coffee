class @DrawingArea
  constructor: (element)->
    @svg = d3.select element
    @element = @svg[0][0]

    @viewBox =
      x: 0
      y: 0
      width: 1000
      height: 1000
      preserveAspectRatio: 'slice'

      update: do (svg = @svg)-> (viewBox)->
        console.log viewBox
        for k, v of viewBox
          @[k] = v
        svg.attr
          viewBox: "#{@x} #{@y} #{@width} #{@height}"
          preserveAspectRatio: @preserveAspectRatio
        @

    $(window).on 'resize', => @resize()
    $ => @resize()

  size: ->
    width: window.innerWidth - container.offsetLeft * 2 - @element.offsetLeft
    height: window.innerHeight - container.offsetTop * 2 - @element.offsetTop

  resize: ->
    size = @size()
    {@width, @height} = size
    @svg.attr size

  container = undefined
  $ => container = $('#container')[0]
