class @DrawingArea
  constructor: (element)->
    @svg = d3.select element
    @element = @svg[0][0]

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
