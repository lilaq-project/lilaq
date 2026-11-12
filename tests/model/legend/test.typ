#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq
#import "../../test-presets.typ"

#show: test-presets.minimal


// Compile-only test for the legend spacing and handle size parameters.

#let plots = (
  lq.plot((1, 2), (1, 2), label: [A]),
  lq.bar((1, 2), (1, 2), label: [B]),
  lq.scatter((1, 2), (2, 1), label: [C]),
)


// Spacing passed through the diagram
#lq.diagram(
  width: 3cm, height: 2cm,
  legend: (
    row-gutter: 1em,
    column-gutter: 1em,
    handle-gap: 0pt,
    handle-width: 1em,
    handle-height: 1em,
    columns: 2,
  ),
  ..plots
)


// Spacing through a set rule
#{
  show: lq.set-legend(row-gutter: 0pt, handle-width: 3em, handle-height: 0.3em)
  lq.diagram(width: 3cm, height: 2cm, ..plots)
}


// Diagram arguments override the set rule
#{
  show: lq.set-legend(handle-width: 3em)
  lq.diagram(
    width: 3cm, height: 2cm, 
    legend: (handle-width: 1em),
    ..plots
  )
}


// Custom legends keep their handles as given
#lq.diagram(
  width: 3cm, height: 2cm,
  legend: lq.legend(
    box(width: 1em, height: 1em, fill: red), [Custom],
    row-gutter: 2em,
  ),
  ..plots
)


// Label size and per-diagram z-index
#lq.diagram(
  width: 3cm, height: 2cm,
  legend: (label-size: 0.6em, z-index: 1, columns: 2),
  ..plots
)
