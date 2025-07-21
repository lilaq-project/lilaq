#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq

#show: lq.set-diagram(
  width: 2cm, height: 2cm
)

#lq.diagram(
  xaxis: (exponent: 1, ticks: none),
  yaxis: (exponent: 1, ticks: none),
)

#pagebreak()


// Check 
#lq.diagram(
  xaxis: (exponent: 1, ticks: none, position: top, mirror: true),
  yaxis: (exponent: 1, ticks: none, position: right, mirror: true),
)