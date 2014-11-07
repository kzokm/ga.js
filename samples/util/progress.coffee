class @Progress
  constructor: (element)->
    @G = $ '<span>'
    @best = $ '<span>'
    $(element)
      .append '<h2>Processing'
      .append ($('<ul>')
        .append ($('<li>')
          .append '<label> Generation Number:'
          .append @G)
        .append ($('<li>')
          .append '<label> Best'
          .append @best))

  update: (popuration)->
    @G.text popuration.generationNumber
    @best.text popuration.best().dump()
