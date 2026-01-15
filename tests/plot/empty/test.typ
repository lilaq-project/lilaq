#import "/src/lilaq.typ" as lq


#set page(width: auto, height: auto, margin: 1pt)

#show: lq.set-legend(stroke: none)
#show: lq.set-tick(inset: 0pt, outset: 0pt)


// Ensure that plots can be called with no coordinates, just to generate a legend entry.

#lq.diagram(
  xaxis: (ticks: (0, 1)),
  yaxis: (ticks: (0, 1)),
  grid: none,
  lq.plot((), (), label: []),
  lq.scatter((), (), label: []),
  lq.bar((), (), label: []),
  lq.bar((), (), width: (), label: []),
  lq.hbar((), (), label: []),
  lq.hbar((), (), width: (), label: []),
  lq.stem((), (), label: []),
  lq.hstem((), (), label: []),
  lq.fill-between((), (), label: []),
  lq.boxplot(label: []),
  lq.hboxplot(label: []),
  lq.violin(label: []),
  lq.hviolin(label: []),
)
