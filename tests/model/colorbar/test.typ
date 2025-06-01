#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq


#let mesh = lq.colormesh(
  (0.3, 1.3),
  (0.3, 1.2),
  // norm: "log",
  (x, y) => x
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
  map: gradient.linear(..color.map.icefire).sharp(9)
)

#lq.colorbar(mesh, orientation: "horizontal")
