#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#show lq.selector(lq.tick-label): none
#show: lq.set-tick(inset: 0pt)
#show: lq.set-diagram(
  // grid: none,
  xaxis: (subticks: none, tick-distance: 1),
  yaxis: (subticks: none, tick-distance: 1),
)
// #lq.diagram(
//   width: 4cm,
//   height: (aspect: .5),
//   yaxis: (tick-distance: 1),
//   xlim: (0, 3),
//   ylim: (0, 4),
//   lq.rect(1, 2, width: 1, height: -1, text(.8em)[]),
//   lq.line(
//     (1,.9),
//     (2,.9),
//   ),
//   lq.line(
//     (.9, 1),
//     (.9, 2),
//   ),
//   lq.place(.7, 1.5)[1],
//   lq.place(1.5, .7)[1],
// )

#lq.diagram(
  width: 3cm,
  height: (aspect: 1),
  xlim: (0, 3),
  ylim: (0, 4)
)

#pagebreak()

#lq.diagram(
  width: (aspect: 2),
  height: 2cm,
  xlim: (0, 2),
  ylim: (0, 5)
)

#pagebreak()

#lq.diagram(
  width: 2cm,
  height: (aspect: .5),
  xlim: (0, 3),
  ylim: (0, 3)
)



#page(width: 2cm, height: auto)[

  #lq.diagram(
    width: 100%,
    height: (aspect: 1),
    xlim: (0, 2),
    ylim: (0, 3)
  )

]


#page(width: auto, height: 2cm)[

  #lq.diagram(
    width: (aspect: 0.5),
    height: 100%,
    xlim: (0, 2),
    ylim: (0, 3)
  )

]

#pagebreak()

#lq.diagram(
  xscale: "log",
  yscale: "log",
  width: 2cm,
  height: (aspect: 1),
  xlim: (1, 100),
  ylim: (1, 100)
)
