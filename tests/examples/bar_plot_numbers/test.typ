#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#let xs = range(9)
#let ys = (12, 51, 23, 36, 38, 15, 10, 22, 86)

#lq.diagram(
  width: 9cm,
  xaxis: (subticks: none),

  lq.bar(
    xs, ys
  ),

  ..xs.zip(ys).map(((x, y)) => {
    let align = if y > 12 { top } else { bottom }
    lq.place(x, y, pad(0.2em)[#y], align: align)
  })
)