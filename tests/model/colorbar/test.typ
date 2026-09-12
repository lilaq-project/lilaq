#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq


#let mesh = lq.colormesh(
  (0.3, 1.3),
  (0.3, 1.2),
  // norm: "log",
  (x, y) => x,
)

#lq.colorbar(mesh, label: "color")

#pagebreak()
#lq.colorbar(mesh, orientation: "horizontal", label: "color")


#pagebreak()


#let mesh = lq.colormesh(
  (0.3, 1.3),
  (0.3, 1.2),
  norm: "log",
  (x, y) => x,
  map: gradient.linear(..color.map.icefire).sharp(9),
)

#lq.colorbar(mesh, orientation: "horizontal")

#pagebreak()

// discretization for contourplots
#let contourplt = lq.contour(
  lq.linspace(-2 * calc.pi, 2 * calc.pi),
  lq.linspace(-2 * calc.pi, 2 * calc.pi),
  (x, y) => calc.sin(x) + calc.cos(y),
  min: -1,
  max: 1,
  levels: lq.linspace(-1, 1, num: 9),
)

#lq.colorbar(contourplt, orientation: "horizontal")
#pagebreak()
#lq.colorbar(contourplt, orientation: "vertical")
