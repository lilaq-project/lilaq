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
    (-3, -2, -1, 0, 1, 2, 5), 
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
