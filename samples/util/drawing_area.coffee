class @DrawingArea
  constructor: (element)->
    @svg = d3.select element
    @element = @svg[0][0]

    $(window).on 'resize', => @resize()
    $ => @resize()

  resize: ->
    @svg.attr
      width: @width = window.innerWidth - container.offsetLeft * 2 - @element.offsetLeft
      height: @height = window.innerHeight - container.offsetTop * 2 - @element.offsetTop

  container = undefined
  $ => container = $('#container')[0]
