#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


#show: lq.set-diagram(
  height: 3cm,
  width: 4cm,
  xaxis: (hidden: true),
  yaxis: (hidden: true),
  grid: none,
  legend: (position: left, dx: 100%),
)


// Basic
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.hbar(
    (5, 3, 4, 2, 1),
    range(5),
  ),
)

#pagebreak()



// Downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.hbar(
    (-5, -3, -4, -2, -1),
    range(5),
    base: 2,
  ),
)

#pagebreak()



// Up- and downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.hbar(
    (-5, -3, -4, -2, -1),
    range(5),
    base: -2,
  ),
)

#pagebreak()



// Cycling
#let hbar = lq.hbar.with(label: [])
#lq.diagram(
  margin: 5%,
  cycle: (
    it => {
      set lq.style(fill: blue)
      it
    },
    it => {
      set lq.style(fill: red, stroke: green)
      it
    },
  ),
  hbar((5,) * 3, (1, 2, 3), base: 4.5),
  hbar((4,) * 3, (1, 2, 3), base: 3.5, stroke: auto),
  hbar((3,) * 3, (1, 2, 3), base: 2.5, fill: green),
  hbar((2,) * 3, (1, 2, 3), base: 1.5, stroke: green),
  hbar((1,) * 3, (1, 2, 3), base: 0.5, fill: none, stroke: auto),
)


#pagebreak()


// Variable width
#lq.diagram(
  lq.hbar(
    (1, 2, 3, 2, 5),
    (1, 2, 3, 4, 5),
    width: (1, .5, 1, .5, 1),
    fill: orange,
    stroke: black,
  ),
)

#pagebreak()


// Variable base
#lq.diagram(
  lq.hbar(
    (1, 2, 3, 0, 5),
    (1, 2, 3, 4, 5),
    base: (0, 1, 2, -1, 0),
    fill: white,
    stroke: .7pt,
  ),
)

#pagebreak()


// Align modes
#lq.diagram(
  lq.hbar(
    (1, 2, 3, 4, 5),
    (1, 2, 3, 4, 5),
    width: .2,
    fill: red,
    align: top,
  ),
  lq.hbar(
    (5, 4, 3, 2, 1),
    (1, 2, 3, 4, 5),
    width: .2,
    fill: blue,
    align: bottom,
  ),
  lq.hbar(
    (2.5,) * 5,
    (1, 2, 3, 4, 5),
    width: .2,
    fill: rgb("#AAEEAA99"),
    align: center,
  ),
)

#pagebreak()


// Variable offset
#lq.diagram(
  lq.hbar(
    (1, 2, 3, 4, 5),
    (1, 2, 3, 4, 5),
    width: .2,
    offset: 0,
    fill: purple,
    align: top,
  ),
  lq.hbar(
    (0.5, 1.5, 2.5, 3.5, 4.5),
    (1, 2, 3, 4, 5),
    width: .2,
    offset: .2,
    fill: yellow,
    align: top,
  ),
  lq.hbar(
    (0, 1, 2, 3, 4),
    (1, 2, 3, 4, 5),
    width: .2,
    offset: .4,
    fill: rgb("#AAEEDDFF"),
    align: top,
  ),
)


#pagebreak()


// Tiling fill
#lq.diagram(
  lq.hbar(
    (.5, 3, 0, 1, .2),
    (1, 2, 3, 4, 5),
    width: .5,
    fill: tiling(line(length: 1cm, angle: 45deg)),
    stroke: 1pt,
    align: top,
  ),
)


#pagebreak()


// 0 vs nan
#lq.diagram(
  lq.hbar(
    (0, 2, 3, float.nan, 11),
    (1, 2, 3, 4, 5),
    fill: aqua,
    stroke: 4pt + aqua.darken(50%),
  ),
)


#pagebreak()


// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.hbar(
    (-5, -3, -4, -2, -1),
    range(5),
    stroke: red,
    base: -2,
  ),
)

#pagebreak()


// Variable offset

#lq.diagram(
  lq.hbar(
    (2, 3, 4, 5, 6),
    range(5),
    offset: (.5, 0, 0, -.5, 0),
    width: .5,
  ),
)

#pagebreak()


// Non-unit stepped range
#lq.diagram(
  lq.hbar(
    (2, 3, 4, 5, 6),
    range(0, 400, step: 100) + (500,),
  ),
)
