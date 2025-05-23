#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


#lq.diagram(
  ylim: (0, 7),
  lq.vlines(1, 1.1, stroke: teal),
  lq.vlines(2, stroke: blue, min: 2),
  lq.vlines(3, stroke: purple, max: 2),
  lq.vlines(4, stroke: red, min: 1, max: 3),
)



#pagebreak()


// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  ylim: (0, 7),
  lq.vlines(1, 1.1, stroke: teal),
  lq.vlines(2, stroke: blue, min: 2),
  lq.vlines(3, stroke: purple, max: 2),
  lq.vlines(4, stroke: red, min: 1, max: 3),
)
