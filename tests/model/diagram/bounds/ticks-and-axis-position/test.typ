#set page(width: auto, height: auto, margin: 1pt)

#import "/src/lilaq.typ" as lq
#import "/tests/test-presets.typ"

#show: test-presets.obfuscate
#show: test-presets.minimal

#show: lq.set-tick(inset: 20pt, outset: 10pt)

#show: lq.set-diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  xaxis: (format-ticks: auto, tick-distance: 1, subticks: none),
  yaxis: (format-ticks: auto, tick-distance: 1, subticks: none),
)


// Bottom and left bounds are determined by tick.outset
#lq.diagram(
  xaxis: (position: 0),
  yaxis: (position: 0),
)

#pagebreak()

// Top and right bounds are determined by tick.outset
#lq.diagram(
  xaxis: (position: (align: top, offset: 0), inverted: true),
  yaxis: (position: (align: right, offset: 0), inverted: true),
)

#pagebreak()

// Top and right bounds are determined by tick.inset
#lq.diagram(
  xaxis: (position: 0, inverted: true),
  yaxis: (position: 0, inverted: true),
)

#pagebreak()

// Bottom and left bounds are determined by tick.inset
#lq.diagram(
  xaxis: (position: (align: top, offset: 0)),
  yaxis: (position: (align: right, offset: 0)),
)


#pagebreak()

// Mirror axes (here at the right and top) have no labels (sometimes). Still their bounds need to be computed correctly.
#lq.diagram(
  xaxis: (format-ticks: none),
  yaxis: (format-ticks: none),
)

#pagebreak()

// Same but now mirrors at the left and bottom
#lq.diagram(
  xaxis: (format-ticks: none, position: top, mirror: true),
  yaxis: (format-ticks: none, position: right, mirror: true),
)
