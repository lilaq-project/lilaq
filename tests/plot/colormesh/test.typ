#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *


#show: minimal


#lq.diagram(
  lq.colormesh(
    lq.linspace(-4, 4, num: 11), 
    lq.linspace(-4, 4, num: 10), 
    (x, y) => x * y, 
  )
)



#pagebreak()


// Norm, map, and holes
#{
  let x = lq.linspace(-4, 4, num: 10)
  let z = lq.mesh(x, x, (x, y) => x*y)
  z.at(2).at(2) = float.nan

  set page(fill: none)
  lq.diagram(
    lq.colormesh(
      x, x,
      z, 
      norm: lq.scale.symlog(base: 10, threshold: 3),
      map: color.map.magma
    )
  )

}


#pagebreak()

// Constrained values and non-evenly spaced coordinates

#lq.diagram(
  xlim: (-5, 6.5),
  ylim: (-3.5, 6.5),
  lq.colormesh(
    (-4, -2, -1, 0, 1, 2, 5), 
    (-4, -2, -1, 0, 1, 2, 5), 
    (x, y) => x * y, 
    min: -5, max: 5,
  )
)


#pagebreak()



// Custom norm

#lq.diagram(
  lq.colormesh(
    lq.linspace(-20, 20, num: 11), 
    lq.linspace(-20, 20, num: 10), 
    (x, y) => x * y, 
    norm: x => x*x*x,
  )
)



#pagebreak()



// Smooth interpolation and gradient as map

#lq.diagram(
  lq.colormesh(
    lq.linspace(-20, 20, num: 11), 
    lq.linspace(-20, 20, num: 10), 
    (x, y) => x * y, 
    map: gradient.linear(red, white, blue),
    interpolation: "smooth"

  )
)



#pagebreak()

// Inverted axes
#{

  show: lq.set-diagram(width: 2cm, height: 2cm)
  let colormesh = lq.colormesh(
    lq.linspace(0, 1, num: 3),
    lq.linspace(0, 1, num: 3),
    (x, y) => x*y
  )
  
  grid(
    columns: 2,
    lq.diagram(colormesh),
    lq.diagram(colormesh, xaxis: (inverted: true)),
    lq.diagram(colormesh, yaxis: (inverted: true)),
    lq.diagram(colormesh, yaxis: (inverted: true), xaxis: (inverted: true)),
  )
}


#pagebreak()


// Zoomed-in case, see #95
#lq.diagram(
  ylim: (0, .8),
  xlim: (0, .8),
  width: 3cm,
  height: 3cm,
  yaxis: (subticks: 3, tick-distance: .5),
  xaxis: (subticks: 3, tick-distance: .5),

  lq.colormesh(
    lq.linspace(0, 1, num: 5),
    lq.linspace(0, 1, num: 5),
    (x, y) => 2 * x * y,
    min: -.3,
  ),
)


#pagebreak()


// Masking out-of-bounds values
#lq.diagram(
  lq.colormesh(
    lq.linspace(-4, 4, num: 6), 
    lq.linspace(-4, 4, num: 6), 
    (x, y) => x * y, 
    min: -2,
    max: 15,
    excess: "mask",
  )
)

#pagebreak()


#lq.diagram(
  xscale: "symlog",

  lq.colormesh(
    lq.arange(-4, 4) + (4.01,), 
    lq.arange(-4, 4) + (4.01,), 
    (x, y) => x * y, 
  )
)
