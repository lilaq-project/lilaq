#set page(width: auto, height: auto, margin: 2pt)


#import "/src/lilaq.typ" as lq
#import "/tests/test-presets.typ": obfuscate, minimal

#show: obfuscate
#show: minimal

#show: lq.set-diagram(
  width: 2cm, 
  height: 2cm,
)





#lq.diagram(
  yaxis: (mirror: false),
  xaxis: none
)

#pagebreak()


#lq.diagram(
  yaxis: (mirror: (ticks: true, tick-labels: true)),
  xaxis: none
)



#pagebreak()

// Auto mirror: not shown with secondary axis
#lq.diagram(
  lq.yaxis(
    position: right,
    functions: (x => x * x, y => calc.sqrt(y))
  ),
  lq.xaxis(
    position: top,
    functions: (x => x * x, y => calc.sqrt(y))
  )
)


#pagebreak()

// Auto mirror: not shown when position is not a side
#lq.diagram(
  xaxis: (position: 0.5),
  yaxis: (position: 0.5),
)

