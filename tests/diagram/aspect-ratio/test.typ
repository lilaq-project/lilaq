#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#show: lq.set-diagram(
  xaxis: (subticks: none, tick-distance: .5),
  yaxis: (subticks: none, tick-distance: .5),
  // grid: none
)

#show lq.selector(lq.tick-label): none

#lq.diagram(
  aspect-ratio: 1,
  lq.ellipse(0, 0, width: 1, height: 1),
)

#pagebreak()

#lq.diagram(
  aspect-ratio: 2,
  lq.rect(0, 0, width: 1, height: 1),
)

#pagebreak()

#lq.diagram(
  aspect-ratio: .5,
  margin: 0%,
  lq.rect(0, 0, width: 1, height: 1),
)

#pagebreak()


#lq.diagram(
  aspect-ratio: 1,
  margin: (rest: 0%),
  lq.plot((1, 10, 100), (1, 10, 100)),
  xscale: "log",
  yscale: "log",
  // height: 8cm
)


#pagebreak()

// Fixed upper x limit
#lq.diagram(
  width: 5cm,
  height: 8cm,
  aspect-ratio: 1,
  margin: (top: 0%, bottom: 0%, left: 20%, right: 20%),
  xlim: (auto, 1),
  lq.ellipse(0, 0, width: 1, height: 1),
)

#pagebreak()

// Fixed upper y limit
#lq.diagram(
  width: 5cm,
  height: 3cm,
  aspect-ratio: 1,
  margin: (top: 0%, bottom: 0%, left: 0%, right: 0%),
  ylim: (0, 1),
  lq.ellipse(0, 0, width: 1, height: 1),
)

#pagebreak()


#set page(width: 5cm, height: 3cm)


#lq.diagram(
  width: 100%,
  height: 100%,
  aspect-ratio: 1,
  margin: (top: 0%, bottom: 0%, left: 0%, right: 0%),
  xlim: (auto, 1.2),
  lq.ellipse(0, 0, width: 1, height: 1),
)

#set page(width: auto, height: auto)

#lq.diagram(
  aspect-ratio: 1, 
  margin: 20%,
  lq.rect(0, 0, width: 1, height: 1),
)

#pagebreak()

#lq.diagram(
  aspect-ratio: 1,
  margin: (rest: 0%, left: 50%, top: 50%),
  lq.rect(0, 0, width: 1, height: 1),
  height: 5cm, width: 3cm,
)
