
#import "/src/lilaq.typ" as lq


#set page(width: auto, height: auto, margin: 1pt)





#let data = (
  1,
  1,
  0.031,
  -0.54,
  -0.21,
  -0.36,
  -0.73,
  -0.16,
  0.022,
  0.121,
  -0.11,
  -1.10,
  -0.29,
  0.237,
  -0.22,
  -1.71,
  0.495,
  1.160,
  1.904,
  2.1,
)



// Simple violin plot example
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.violin(
    (1, 2, 3, 4, 5, 6, 7, 8, 3, 4, 4, 2, 12),
    (1, 3, 4, 5, 5, 5, 5, 6, 7, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
    label: [A],
  ),
  // lq.violin(
  //   (1, 2, 3, 4, 5, 6, 7, 8, 3, 4, 4, 2, 12),
  //   (1, 3,4,5,5,5,5,6,7, 12),
  //   (5, 6, 7, 8, 9, 10, 11, 12),
  //   label: [A]
  // )
)
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.violin(
    boxplot-fill: white,
    // boxplot-stroke: black,
    (1, 2, 3, 4, 5, 6, 7, 8, 3, 4, 4, 2, 12),
    (1, 3, 4, 5, 5, 5, 5, 6, 7, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
    label: [A],
  ),
)

#pagebreak()
#lq.diagram(
  xaxis: (inverted: true),
  ..range(10).map(i => lq.violin(range(10), x: i)),
)


// Violin plot with mean marker
#lq.diagram(
  height: 6cm,
  width: 8cm,
  lq.violin(
    (1, 2, 3, 4, 5, 6, 7, 8, 9, 3, 4, 5),
    range(2, 12),
    (5, 6, 7, 8, 9, 10, 11, 12),
    mean: "x",
    // fill: blue.lighten(70%),
    boxplot: false,
    stroke: blue.darken(20%),
  ),
)

