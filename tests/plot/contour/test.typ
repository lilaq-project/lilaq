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


// level behaviour with min/max
#pagebreak()

#{
  let F = 1000 // N
  let l = 1100 // mm
  let S = 1.34
  
  let (b, h) = (30, lq.linspace(40, 115, num: 30))
  let ws = lq.linspace(1, 9, num: 30)
  
  let Mb = F * l
  
  let I(b, h, ws) = {
    b * calc.pow(h, 3) / 12 - (b - 2 * ws) * calc.pow(h - 2 * ws, 3) / 12
  }
  let sigma(ws, h) = {
    Mb / I(b, h, ws) * h / 2 * S
  }
  
  lq.diagram(
    lq.contour(
      ws,
      h,
      sigma,
      fill: true,
      levels: 10,
      min: 0,
      max: 1000,
    ),
    // There should be a step visible below the dotted line
    lq.contour(
      ws,
      h,
      sigma,
      fill: false,
      levels: (100,),
      stroke: (paint: black, thickness: 0.7pt, dash: "dotted"),
    ),
  )
}
