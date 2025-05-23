#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


#lq.diagram(
  xlim: (0, 7),
  lq.hlines(1, 1.1, stroke: teal),
  lq.hlines(2, stroke: blue, min: 2),
  lq.hlines(3, stroke: purple, max: 2),
  lq.hlines(4, stroke: red, min: 1, max: 3),
)


#pagebreak()


// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  xlim: (0, 7),
  lq.hlines(1, 1.1, stroke: teal),
  lq.hlines(2, stroke: blue, min: 2),
  lq.hlines(3, stroke: purple, max: 2),
  lq.hlines(4, stroke: red, min: 1, max: 3),
)
