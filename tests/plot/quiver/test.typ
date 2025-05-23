#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


#let x = lq.arange(-2, 3)
#let y = lq.arange(-2, 3)
#lq.diagram(
  lq.quiver(
    x, y, 
    (x, y) => (x + y, y - x), 
    label: []
  )
)



#pagebreak()


#let (directions) = lq.mesh(x, y, (x, y) => (x + y, y - x))
#{
  directions.at(0).at(4) = (float.nan, 1)
}


#show: lq.set-diagram(
  xlim: (-3, 3),
  ylim: (-3, 3),
  // grid: 1pt + luma(80%)
)




// Pivot end

#lq.diagram(
  lq.quiver(x, y, directions, pivot: end),
)


#pagebreak()



// Pivot center

#lq.diagram(
  lq.quiver(x, y, directions, pivot: center),
)


#pagebreak()



// Pivot start

#lq.diagram(
  lq.quiver(x, y, directions, pivot: start),
)


#pagebreak()



#import "@preview/tiptoe:0.3.1"

#lq.diagram(
  lq.quiver(
    x, y, directions, 
    tip: tiptoe.circle,
    toe: tiptoe.bar,
    pivot: start, 
    stroke: .5pt, color: red
  )
)


#pagebreak()



// Coloring

#lq.diagram(
  lq.quiver(
    lq.arange(-2, 3),
    lq.arange(-2, 3),
    (x, y) => (x + y*2, y - x),
    color: (x, y, u, v) => calc.norm(u, v),
    pivot: start, 
  )
)


#pagebreak()



// Coloring with norm and min/max

#lq.diagram(
  lq.quiver(
    lq.arange(-2, 3),
    lq.arange(-2, 3),
    (x, y) => (x + y*2, y - x),
    color: (x, y, u, v) => calc.norm(u, v),
    norm: "symlog",
    min: 1, 
    max: 4,
    pivot: start, 
  )
)

#pagebreak()



// auto scale

#lq.diagram(
  lq.quiver(
    lq.linspace(-3, 3, num: 15),
    lq.linspace(-3, 3, num: 15),
    (x, y) => (x, y), 
  ),
)



#pagebreak()


// Manual scale
#lq.diagram(
  lq.quiver(
    lq.linspace(-3, 3, num: 15),
    lq.linspace(-3, 3, num: 15),
    (x, y) => (x, y), 
    scale: .1
  )
)



#pagebreak()


// Manual scale
#lq.diagram(
  lq.quiver(
    lq.linspace(-3, 3, num: 5),
    lq.linspace(-3, 3, num: 5),
    (x, y) => (x, y), 
    stroke: red + 1pt
  )
)


#pagebreak()



// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.quiver(
    lq.arange(-2, 3),
    lq.arange(-2, 3),
    (x, y) => (x + y, y - x), 
  )
)