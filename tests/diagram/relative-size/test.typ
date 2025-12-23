#import "/src/lilaq.typ" as lq
#import "/tests/test-presets.typ": obfuscate

#show: obfuscate

#set page(width: 6cm, height: 4cm, margin: 0pt)


#show: lq.set-diagram(
  xlim: (-.1, 1.1),
  ylim: (-.1, 1.1),
  yaxis: (tick-distance: .5),
  grid: none
)

// Data-area based dimensions
#lq.diagram(
  width: 4cm, height: 3cm,
)
#pagebreak()

// Ratio width
#lq.diagram(
  width: 50% + 0em, height: 3cm,
)
#pagebreak()

// Ratio height
#lq.diagram(
  width: 4cm, height: 50%,
)
#pagebreak()

// Ratio width and height
#lq.diagram(
  width: 50%, height: 50%,
)

#pagebreak()

// Relative width and height
#lq.diagram(
  width: 50% + 3em, height: 25% + 2em,
)

#pagebreak()


// Complex examples with ticks, attachments and a 
// breaking title. 
#[

  #show: lq.show_(lq.tick-label.with(kind: "x"), rotate.with(-90deg, reflow: true))

  #lq.diagram(
    title: [Very very very long multiline title],
    xaxis: (exponent: 1),
    width: 100%,
    height: 100%,
    xlabel: [x],
    ylabel: [y],
    lq.plot(range(5), x => x)
  )

  #pagebreak()

  #lq.diagram(
    height: 100%, width: 100%,
    title: [Title \ with \ 3 lines \ ],
    yaxis: (exponent: 0, lim: (0, 10000000000), tick-distance: auto),
    xaxis: (exponent: 2 ,mirror: (tick-labels: true)),
    xlabel: [x],
    ylabel: [y],
    lq.plot(
      range(5), 
      range(5)
    ),
  )

]

#pagebreak()


// Axes on top and right
#lq.diagram(
  width: 100%, height: 100%,
  xlim: (0, 0.1),
  xlabel: [x],
  xaxis: (position: top),
  yaxis: (position: right)
)

#pagebreak()


// Axes positioned relative to other axis. 
#{
  show: lq.theme.schoolbook

  lq.diagram(
    width: 100%,
    height: 100%,
  )

}

#pagebreak()


// Exponents at default positions
#lq.diagram(
  width: 100%, height: 100%,
  xaxis: (exponent: 1, ticks: none),
  yaxis: (exponent: 1, ticks: none),
)

#pagebreak()


// Exponents at complimentary positions
#lq.diagram(
  width: 100%, height: 100%,
  xaxis: (exponent: 1, ticks: none, position: top, mirror: true),
  yaxis: (exponent: 1, ticks: none, position: right, mirror: true),
)



#pagebreak()


#lq.diagram(
  width: 100%,
  height: 100%,
  yaxis: (position: right),
  xaxis: (position: -0.2),
)


// Test relative but truly fixed dimensions in unbounded parent page. 


// This is an important assumption for the exception in diagram.typ
// that makes it possible to place a diagram in an unbounded parent
// while specifying width/height of the form 0% + ..cm. 
#assert.eq(float.inf * 1pt * 0%, 0pt)

#page(
  width: auto, height: auto,margin: 0pt,
  lq.diagram(
    width: 0% + 3cm,
    height: 0% + 3cm
  ),
  background: rect(width: 3cm, height: 3cm, stroke: .2pt + red)
)
