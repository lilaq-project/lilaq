#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


// Ratio coordinates and clipping
#lq.diagram(
  lq.place(
    50%, 50%
  )[A],

  lq.place(
    0%, 0%, align: left + top
  )[A],

  lq.place(
    100%, 50%, align: right
  )[A],

  lq.place(
    50%, 100%, align: bottom
  )[A],

  
  lq.place(
    25%, 0%, clip: true, 
  )[clipped],
  lq.place(
    75%, 0%, clip: false, 
  )[unclipped]
)


#pagebreak()

// Data and mixed coordinates
#lq.diagram(
  xlim: (0, 2),
  ylim: (0, 1),

  lq.place(
    0, 0, align: left + bottom
  )[A],
  
  lq.place(
    1, 0.5
  )[A],

  lq.place(
    2, 1, align: right + top
  )[A],

  lq.place(
    1, 0%, align: top
  )[A],

  lq.place(
    1, 1em, align: top
  )[Hey],

  lq.place(
    1em, 1, align: top
  )[Hey],

  
)


#pagebreak()


// Bounds

#show: lq.set-diagram(
  margin: 0%,
  ylim: (0, 1),
  xlim: (0, 2),
  xaxis: (ticks: none, hidden: false),
  yaxis: (ticks: none, hidden: false),
)


#lq.diagram(
  lq.plot((0, 1, 2), (0, 1, 0), mark: none, stroke: blue + 1pt),
  lq.place(1, 1)[A],
  lq.place(100%, 50%, clip: true)[B], // clipped placements are ignored
  lq.place(0, 100%, align: right + top)[C],
)

#pagebreak()


// Bounds
#lq.diagram(
  lq.plot((0, 1, 2), (0, 1, 0), mark: none, stroke: blue + 1pt),
  lq.place(2, .5)[T],
  lq.place(0, -1em, align: right + top)[D],
  lq.place(0, 100%, align: right)[EFG],
)

#pagebreak()


// Datetime
#lq.diagram(
  xlim: (
    datetime(year: 0, month: 1, day: 2),
    datetime(year: 0, month: 1, day: 5),
  ),
  ylim: (
    datetime(year: 0, month: 1, day: 2),
    datetime(year: 0, month: 1, day: 5),
  ),
  lq.place(
    datetime(year: 0, month: 1, day: 3),
    datetime(year: 0, month: 1, day: 4),
  )[o]
)
