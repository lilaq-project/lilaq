#set page(width: 10cm, height: 8cm, margin: 5pt)

#import "/src/lilaq.typ" as lq

// Simple violin plot example
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.violin(
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 3, 4, 5),
    range(2, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
  )
)

#pagebreak()

// Violin plot with mean marker
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.violin(
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 3, 4, 5),
    range(2, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
    mean: "x",
    fill: blue.lighten(70%),
    stroke: blue.darken(20%),
  )
)

#pagebreak()

// Horizontal violin plot
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.hviolin(
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 3, 4, 5),
    range(2, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
    fill: green.lighten(70%),
    stroke: green.darken(20%),
  )
)
