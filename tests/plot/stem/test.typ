#set page(width: auto, height: auto, margin: 1pt)
#import "/src/lilaq.typ" as lq


#show: lq.set-diagram(
  height: 3cm,
  width: 4cm,
  xaxis: (hidden: true),
  yaxis: (hidden: true),
  grid: none,
  legend: (position: left, dx: 100%),
)


// Basic
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.stem(
    range(5),
    (5, 3, float.nan, 0, 1)
  )
)

#pagebreak()



// Downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.stem(
    range(5),
    (-5, -3, -4, -2, -1),
    base: 2,
  )
)

#pagebreak()



// Up- and downwards
#lq.diagram(
  xaxis: (hidden: false, ticks: none),
  lq.stem(
    range(5),
    (-5, -3, -4, -2, -1),
    base: -2,
  )
)

#pagebreak()



// Cycling 
#let stem = lq.stem.with(label: [])
#lq.diagram(
  margin: 5%,
  cycle: (
    it => { set lq.style(fill: blue); it },
    it => { 
      set lq.style(fill: red, stroke: green) 
      set lq.mark(align: lq.marks.x, inset: 2pt)
      it
    },
  ),
  stem((1, 2, 3), (5,)*3, base: 4.5),
  stem((1, 2, 3), (4,)*3, base: 3.5),
  stem((1, 2, 3), (3,)*3, base: 2.5, color: gray),
  stem(
    (1, 2, 3), (2,)*3, 
    base: 1.5, 
    color: gray, stroke: green, 
    mark: "*", mark-size: 5pt
  ),
  stem(
    (1, 2, 3), (1,)*3, 
    base: 0.5, 
    base-stroke: black
  ),
)
