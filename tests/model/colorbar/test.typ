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
#let x = lq.linspace(-2 * calc.pi, 2 * calc.pi)
#let y = lq.linspace(-2 * calc.pi, 2 * calc.pi)
#let fun(x, y) = { calc.sin(x) + calc.cos(y) }

#let contourplt_filled = lq.contour(
  x,
  y,
  fun,
  min: -1,
  max: 1,
  fill: true,
  levels: lq.linspace(-1, 1, num: 9),
)
#let contourplt_lines = lq.contour(
  x,
  y,
  fun,
  min: -1,
  max: 1,
  fill: false,
  levels: lq.linspace(-1, 1, num: 9),
  stroke: 2pt,
)

#lq.colorbar(contourplt_filled, orientation: "horizontal", label: [`filled:true`])
#pagebreak()

#lq.colorbar(contourplt_lines, orientation: "horizontal", label: [`filled:false`])
#pagebreak()

#lq.colorbar(contourplt_filled, orientation: "vertical", label: [`filled:true`])
#pagebreak()

#lq.colorbar(contourplt_lines, orientation: "vertical", label: [`filled:false`])
