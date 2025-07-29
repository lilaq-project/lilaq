#set page(width: auto, height: auto, margin: 0pt)


#import "/src/lilaq.typ" as lq


#set page(width: 6cm, height: 4cm)
#show: lq.set-diagram(
  xlim: (-.1, 1.1),
  ylim: (-.1, 1.1),
  yaxis: (tick-distance: .5),
  grid: none
)


#lq.diagram(
  width: 4cm, height: 3cm,
)

#pagebreak()
#lq.diagram(
  width: 50% +0em, height: 3cm,
)

#pagebreak()
#lq.diagram(
  width: 4cm, height: 50%,
)

#pagebreak()
#lq.diagram(
  width: 50%, height: 50%,
)

#pagebreak()
#lq.diagram(
  width: 50% +3em, height: 25% + 2em,
)


#pagebreak()



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


#lq.diagram(
  width: 100%, height: 100%,
  xlim: (0, 0.1),
  xlabel: [x],
  xaxis: (position: top)
)


#pagebreak()


#{
  show: lq.theme.schoolbook

  box(stroke: 1pt + red, lq.diagram(
    width: 100%,
    height: 100%,
  ))

}

#pagebreak()


// Check powers
#lq.diagram(
  width: 100%, height: 100%,
  xaxis: (exponent: 1, ticks: none),
  yaxis: (exponent: 1, ticks: none),
)

#pagebreak()


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
  xaxis: (position: -.1),
)

