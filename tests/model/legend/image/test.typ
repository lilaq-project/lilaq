#set page(width: auto, height: auto, margin: 2pt)
#import "/src/lilaq.typ" as lq
#import "../../../../src/model/legend.typ": legend-image, e

#show: lq.set-diagram(
  xaxis: none, yaxis: none, grid: none,
  width: 3cm, 
  height: 3cm
)
#show: lq.set-legend(fill: none, stroke: none, radius: 0pt, inset: 0pt)

#show: e.set_(legend-image, width: 1.5em, height: .3em)

#show: e.show_(legend-image.with(kind: lq.plot), it => {
  show lq.mark: set lq.mark(inset: 12pt, fill: silver, stroke: blue)
  show curve: set curve(stroke: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.scatter), it => {
  show lq.mark: set lq.mark(inset: 7pt, fill: silver, align: lq.marks.at("d"))
  it
})

#show: e.show_(legend-image.with(kind: lq.bar), it => {
  show rect: set rect(fill: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.stem), it => {
  show lq.mark: set lq.mark(align: lq.marks.a5, stroke: green)
  it
})

#show: e.show_(legend-image.with(kind: lq.hbar), it => {
  show rect: set rect(fill: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.hstem), it => {
  show lq.mark: set lq.mark(align: lq.marks.a5, stroke: green)
  it
})

#show: e.show_(legend-image.with(kind: lq.fill-between), it => {
  show polygon: set polygon(fill: purple)
  it
})


#lq.diagram(
  lq.plot(
    (0, 1.5,), (5, 5,),
    color: red,
    mark-size: 7pt,
    label: []
  ),
  lq.scatter(
    (0, 1.5),
    (4.5, 4.5),
    size: 5pt,
    color: (1, 2),
    label: []
  ),
  lq.bar(
    (0, 1.5),
    (4, 4),
    width: .5, 
    base: 3.5,
    fill: (orange, green),
    label: []
  ),
  lq.stem(
    (0, 1.5),
    (3, 3),
    base: 2.5,
    color: purple,
    label: []
  ),
  lq.hbar(
    (.5, .5),
    (0.5, 1.5),
    fill: (orange, green),
    label: []
  ),
  lq.hstem(
    (1.5, 1.5),
    (0.5, 1.5),
    base: 1, 
    color: purple,
    label: []
  ),
  lq.fill-between(
    (0, .5, 2, 3),
    (0, .5, 1, .5),
    fill: purple.transparentize(50%),
    label: []
  )
)


#pagebreak()

#show: e.show_(legend-image.with(kind: lq.colormesh), it => {
  show rect: set rect(fill: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.contour), it => {
  show line: set line(stroke: red)
  it
})

#show: e.show_(legend-image.with(kind: lq.quiver), it => {
  line(length: 100%)
})


#lq.diagram(
  lq.colormesh(
    (0, 1), (0, 1),
    (x, y) => x + y,
    label: []
  ),
  lq.contour(
    (0, 1), (0, 1),
    (x, y) => x + y,
    levels: (0,),
    label: []
  ),
  lq.quiver(
    (0, 1), (0, 1),
    (x, y) => (x + 1, y + 1),
    label: []
  )
)


#pagebreak()


// Shapes

#show: e.show_(legend-image.with(kind: lq.rect), it => {
  show rect: set rect(fill: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.ellipse), it => {
  show ellipse: set ellipse(fill: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.line), it => {
  show line: set line(stroke: blue)
  it
})

#show: e.show_(legend-image.with(kind: lq.path), it => {
  polygon(
    (0%, .7em),
    (50%, 0em),
    (100%, .7em),
    fill: blue
  )
})

#lq.diagram(
  lq.rect(0, 0, width: 1, height: 1, fill: red, label: []),
  lq.ellipse(2, 0, width: 1, height: 1, fill: yellow, label: []),
  lq.line((0, 1.5), (1,2), stroke: red, label: []),
  lq.path((2, 1.5), (2,2), (1.5, 1.5), fill: black, label: []),
)