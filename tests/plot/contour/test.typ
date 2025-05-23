#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


// Stroked

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    levels: 7,
  )
)


#pagebreak()



// Filled

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    fill: true,
    levels: 7
  )
)


#pagebreak()



// Styling, norm and min/max

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    levels: 7,
    stroke: (dash: "dashed", thickness: .5pt),
    map: color.map.turbo,
    norm: "symlog",
    min: -3,
    max: 3,
  )
)


#pagebreak()



// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) =>  y*x - x*x - x,
    fill: true,
    levels: 7
  )
)


#pagebreak()



// Matplotlib contour plot example

#{
  let x = lq.linspace(-3, 3, num: 40)
  let y = lq.linspace(-3, 3, num: 40)
  let z = lq.mesh(x, y, 
    (x, y) => (1 - x/2 + calc.pow(x, 5) + calc.pow(y, 3)) * calc.exp(-x*x - y*y)
  )
  let (zmin, zmax) = lq.minmax(z.flatten())
  lq.diagram(
    lq.contour(
      x, y, z, 
      fill: true, 
      levels: lq.linspace(zmin, zmax, num: 7)
    )
  )
}
