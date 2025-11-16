#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq


#show: lq.set-title(pad: 0pt)
#show: lq.set-diagram(
  xaxis: (ticks: none),
  yaxis: (ticks: none),
)

#let title = box(height: 30pt, fill: black, width: 1em)

#show lq.selector(lq.title): rotate.with(90deg, reflow: true)

#lq.diagram(
  height: 3pt,
  title: title,
)


#pagebreak()

#show: lq.set-title(position: bottom)
#lq.diagram(
  height: 3pt,
  title: title,
)


#pagebreak()

#show: lq.set-title(position: right)
#lq.diagram(
  width: 3pt,
  title: title,
)


#pagebreak()

#show: lq.set-title(position: left)
#lq.diagram(
  width: 3pt,
  title: title,
)
