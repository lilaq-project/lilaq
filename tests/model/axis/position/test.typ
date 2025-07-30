#set page(width: auto, height: auto, margin: 2pt)


#import "/src/lilaq.typ" as lq


#let test-grid = grid(
  columns: 2, 
  row-gutter: 2pt,
  column-gutter: 2pt,
  lq.diagram(
    xlim: (-1, 2),
    ylim: (.3, .7),
    yaxis: (position: (align: left, offset: 0)),
    xaxis: (ticks: none)
  ),
  lq.diagram(
    ylim: (-1, 2),
    xlim: (.3, .7),
    xaxis: (position: (align: top, offset: 0)),
    yaxis: (ticks: none)
  ),


  lq.diagram(
    xlim: (-1, 2),
    ylim: (.3, .7),
    yaxis: (position: (align: right, offset: 0)),
    xaxis: (ticks: none)
  ),
  lq.diagram(
    ylim: (-1, 2),
    xlim: (.3, .7),
    xaxis: (position: (align: bottom, offset: 0)),
    yaxis: (ticks: none)
  ),
)




#show: lq.set-diagram(
  width: 2cm, 
  height: 2cm,
  grid: none
)

#test-grid


// And the same with diagrams and relative sizes
#set page(width: 4cm, height: 4cm)
#set grid(rows: (1fr, 1fr))

#show: lq.set-diagram(
  width: 100%, 
  height: 100%
)


#test-grid
