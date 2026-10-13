#set page(width: auto, height: auto, margin: 5pt, fill: rgb("#18191c"))
#set text(fill: rgb("#e8eaed"))
#import "/tests/test-presets.typ": *
#show: obfuscate

// Spines, ticks, the grid and the legend take their colors from the text and
// the page, so a diagram on a dark page needs no styles of its own. The
// subtick grid lines inherit from the main ones.
#show: lq.set-grid(stroke-sub: auto)

#lq.diagram(
  width: 4cm,
  height: 3cm,
  xaxis: (subticks: 1, extra-ticks: (0.5,)),
  yaxis: (subticks: 1),
  lq.plot((0, 1, 2), (1, 3, 2), label: [A]),
)
