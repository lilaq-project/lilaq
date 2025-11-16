#import "/src/lilaq.typ" as lq

// Make reference images smaller by obscuring text
#let mask = it => box(fill: gray, hide(it))

#show lq.selector(lq.tick-label): mask
#show lq.selector(lq.label): mask
#show lq.selector(lq.title): mask

#show: lq.set-legend(
  stroke: 1pt + black,
  radius: 0pt
)


#show: lq.set-tick(inset: 0pt, outset: 0pt)
#show: lq.set-diagram(
  grid: none,
  xaxis: (tick-args: (density: 50%)),
  yaxis: (tick-args: (density: 50%)),
)

#show: lq.layout
#set grid(stroke: gray)


#set page(width: auto, height: auto, margin: 5pt)
#show: lq.set-diagram(width: 4cm, height: 3cm)

// Fixed diagram dimensions, automatic grid
// - rows
#grid(
  lq.diagram(
    ylim: (10, 100), 
  ),
  lq.diagram(
    ylim: (1, 5),
    yaxis: (mirror: (ticks: true, tick-labels: true))
  )
)

#pagebreak()

// - columns
#grid(
  columns: 2,
  lq.diagram(title: [A]),
  lq.diagram(xlabel: [X]),
)


#pagebreak()

// Automatic diagram dimensions, filling grid 
#show: lq.set-diagram(width: 100%, height: 100%)

#set page(width: 8cm, height: 6cm)

#grid(
  columns: (1fr, 1.5fr),
  rows: (1fr, 1.5fr),
  column-gutter: 1em,
  row-gutter: 1em,
  lq.diagram(title: [A]),
  lq.diagram(),
  lq.diagram(xaxis: (position: top, mirror: true)),
  lq.diagram(
    yaxis: (position: right, mirror: true), 
    xlabel: [x]
  )
)

#pagebreak()


// Legend (nested grid)

#grid(
  columns: (1fr),
  rows: (1fr, 1.5fr),
  column-gutter: 1em,
  row-gutter: 1em,
  lq.diagram(),
  lq.diagram(
    legend: (position: left, dx: 100%),
    lq.bar((), (), label: [])
  )
)





#pagebreak()


// Row- and colspans

#set page(height: auto, width: 10cm)
#grid(
  columns: 3,
  rows: (4cm, 3cm),
  // stroke: red,
  column-gutter: 2pt, 
  row-gutter: 2pt, 
  grid.cell(
    lq.diagram(
      yaxis: (position: left),
      lq.yaxis(position: right, label: [Distance]),
      ylabel: [Intensity],
    ),
    colspan: 3
  ),
  lq.diagram(
    title: [A], 
  ),
  grid.cell(
    lq.diagram(
      ylabel: [offset], ylim: (0, 9), 
      let mesh = lq.contour(
        lq.linspace(0, 1),
        lq.linspace(0, 9),
        (x, y) => 2*x*y
      ),
      // mesh
    ),
    rowspan: 2
  ),
  grid.cell(
    lq.colorbar(mesh, width: 11.1pt),
    rowspan: 2
  ),
  lq.diagram(
    title: [B],
    ylim: (1, 3),
  ),
)






// #pagebreak()

// // #show: lq.set-diagram(width: 100%)
// // #show grid: layout



// // #grid(
// //   columns: (8cm, 3cm),
// //   lq.diagram(),
// //   box(stroke: black)[Hello],
// //   lq.diagram(),
// //   lq.diagram(),
// // )

// // #pagebreak()

// #show: lq.set-diagram(height: 4cm)
// #set page(paper: "a4")

// #grid(
//   columns: (1fr, 1fr),
//   // rows: 1fr,
//   column-gutter: 1em,
//   row-gutter: 1em,
//   stroke: red,
//   lq.diagram(ylim: (-100, 10), title: [A ss asdd bb]),
//   lq.diagram(ylim: (1, 5)),
//   lq.diagram(xaxis: (position: top)),
//   lq.diagram(yaxis: (position: right, mirror: (ticks: true, tick-labels: true)), ylim: (-100, 10)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(xaxis: (position: top)),
//   lq.diagram(),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
// )

// // #show: lq.set-diagram(height: 4cm)
// // #show lq.selector(lq.legend): none

// #grid(
//   columns:1,
//   // column-gutter: 1em,
//   // row-gutter: 1em,
//   stroke: red,
//   lq.diagram(
//     legend: (position: left, dx: 100%),
//     // legend: none,
//     lq.plot((1, 2), (3, 4), label: [A])
    
//   ),
//   lq.diagram(ylim: (1, 5), yaxis: (position: right)),
// )


// == Effect of non-adapting axis (a bearable compromise)
// #grid(
//   columns: (1fr, ),
//   lq.diagram(
//     legend: (position: left, dx: 100%+16em),
//     lq.plot((1, 1.8), (3, 4), label: [A])
//   ),
//   lq.diagram(
//     lq.plot((1, 1.8), (3, 4))
//   )
// )
// The first time, the first diagram is measured, it already needs a lot of space and thus the data area only occupies around half of the page width. So, the tick locator knows about the size and adapts the optimal tick distance correctly. In the second measurement, it still looks the same. 

// When the second diagram is measured for the first time, however, it occupies the entire text width and therefore is allowed to generate denser ticks. During the second measurement, the width is adapted to the width of the first diagram but the ticks aren't allowed to change anymore (to avoid a non-converging layout). 

// #pagebreak()

// #show: lq.set-diagram(width: 100%, height: 100%)

// #grid(
//   columns: 3,
//   rows: 4cm,
//   // stroke: red,
//   column-gutter: 1.5em, 
//   row-gutter: 1em, 
//   grid.cell(
//     lq.diagram(
//       yaxis: (position: left),
//       lq.yaxis(position: right, label: [Distance]),
//       ylabel: [Intensity],
//     ),
//     colspan: 3
//   ),
//   lq.diagram(
//     title: [A], 
//     lq.plot(lq.linspace(0, 3), x => x*x)
//   ),
//   grid.cell(
//     lq.diagram(
//       ylabel: [offset], ylim: (0, 9), 
//       let mesh = lq.contour(
//         lq.linspace(0, 1),
//         lq.linspace(0, 9),
//         (x, y) => 2*x*y
//       ),
//       mesh
//     ),
//     rowspan: 2
//   ),
//   grid.cell(
//     lq.colorbar(mesh, width: 11.1pt),
//     rowspan: 2
//   ),
//   lq.diagram(
//     title: [B],
//     lq.plot(lq.linspace(0.1, 9), x => 2*calc.sin(x)/calc.pow(x, 1))
//   ),
//   // [],
//   // lq.diagram(title: [C], xlabel: [x]),
// )