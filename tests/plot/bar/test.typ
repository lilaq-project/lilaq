#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


// Basic
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.bar(
    range(5),
    (5,3,4,2,1)
  )
)

#pagebreak()



// Downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.bar(
    range(5),
    (-5,-3,-4,-2,-1),
    base: 2,
  )
)

#pagebreak()



// Up- and downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.bar(
    range(5),
    (-5,-3,-4,-2,-1),
    base: -2,
  )
)

#pagebreak()



// Cycling 
#let bar = lq.bar.with(label: [])
#lq.diagram(
  margin: 5%,
  cycle: (
    it => { set lq.style(fill: blue); it },
    it => { 
      set lq.style(fill: red, stroke: green) 
      it
    },
  ),
  bar((1, 2, 3), (5,)*3, base: 4.5),
  bar((1, 2, 3), (4,)*3, base: 3.5, stroke: auto),
  bar((1, 2, 3), (3,)*3, base: 2.5, fill: green),
  bar((1, 2, 3), (2,)*3, base: 1.5, stroke: green),
  bar((1, 2, 3), (1,)*3, base: 0.5, fill: none, stroke: auto),
)


#pagebreak()


// Variable width
#lq.diagram(
  lq.bar(
    (1, 2, 3, 4, 5), 
    (1, 2, 3, 2, 5), 
    width: (1, .5, 1, .5, 1), 
    fill: orange, 
    stroke: black, 
  ),
)

#pagebreak()


// Variable base
#lq.diagram(
  lq.bar(
    (1, 2, 3, 4, 5), 
    (1, 2, 3, 0, 5), 
    base: (0, 1, 2, -1, 0), 
    fill: white, 
    stroke: .7pt, 
  )
)

#pagebreak()


// Align modes
#lq.diagram(
  lq.bar(
    (1,2,3,4,5), (1,2,3,4,5), 
    width: .2, 
    fill: red, 
    align: left, 
  ),
  lq.bar(
    (1,2,3,4,5), (5,4,3,2,1), 
    width: .2, 
    fill: blue, 
    align: right, 
  ),
  lq.bar(
    (1,2,3,4,5), (2.5,) * 5, 
    width: .2, 
    fill: rgb("#AAEEAA99"),
    align: center, 
  ),
)

#pagebreak()


// Variable offset
#lq.diagram(
  lq.bar(
    (1,2,3,4,5), (1,2,3,4,5), 
    width: .2, 
    offset: 0, 
    fill: purple, 
    align: left, 
  ),
  lq.bar(
    (1,2,3,4,5), (0.5,1.5,2.5,3.5,4.5), 
    width: .2, 
    offset: .2,
    fill: yellow, 
    align: left, 
  ),
  lq.bar(
    (1,2,3,4,5), (0,1,2,3,4), 
    width: .2, 
    offset: .4,
    fill: rgb("#AAEEDDFF"), 
    align: left, 
  ),
) 


#pagebreak()


// Tiling fill
#lq.diagram(
  lq.bar(
    (1,2,3,4,5), (.5,3,0,1,.2), 
    width: .5, 
    fill: tiling(line(length: 1cm, angle: 45deg)),
    stroke: 1pt,
    align: left
  ),
)


#pagebreak()


// 0 vs nan
#lq.diagram(
  lq.bar(
    (1,2,3,4,5), (0,2,3,float.nan,11), 
    fill: aqua, 
    stroke: 4pt + aqua.darken(50%)
  ),
)


#pagebreak()


// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.bar(
    range(5),
    (-5,-3,-4,-2,-1),
    stroke: red,
    base: -2,
  )
)