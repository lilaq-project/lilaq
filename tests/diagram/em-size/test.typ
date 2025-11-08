#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#show: lq.set-diagram(
  xaxis: (ticks: none),
  yaxis: (ticks: none),
  grid: none
)

#lq.diagram(
  width: 4em, height: 2em
)


#pagebreak()

#set page(width: 5em + 10pt, height: 5em + 10pt)
#lq.diagram(
  width: 100% - 1em,
  height: 100% - 1em
)

