class @Progress
  constructor: (element)->
    @G = $ '<span>'
    @best = $ '<span>'
    $(element)
      .prepend ($('<ul>')
        .append ($('<li>')
          .append '<label> Generation Number:'
          .append @G)
        .append ($('<li>')
          .append '<label> Best'
          .append @best))
      .prepend '<h2>Processing...'

  update: (population)->
    @G.text population.generationNumber
    @best.text population.best.dump()
