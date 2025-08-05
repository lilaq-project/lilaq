#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq

#show: lq.set-label(pad: none)

#lq.diagram(
  xaxis: (ticks: (.2, .8)),
  yaxis: (ticks: (.2, .8)),
  width: 2cm,
  height: 2cm,
  xlabel: $x$,
  ylabel: $y$
)