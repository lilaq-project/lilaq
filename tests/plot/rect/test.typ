#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
// #show: minimal


#show: lq.set-diagram(
  margin: 5%,
  height: 4cm,
  width: 6cm,
)

// Only data coordinates
#lq.diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  lq.rect(1, 1, width: 1, height: 1),
  lq.rect(1, 1, width: 1, height: 1, align: right, stroke: blue),
  lq.rect(
    1,
    1,
    width: 1,
    height: 1,
    align: left + bottom,
    fill: red,
    radius: 20%,
  ),
)

#pagebreak()

// nonlinear scale
#lq.diagram(
  xscale: "log",
  yscale: "log",
  xlim: (1, 3),
  ylim: (1, 3),
  lq.rect(2, 2, width: .5, height: 0.5),
  lq.rect(2, 2, width: .5, height: 0.5, align: right + bottom),
)

#pagebreak()

// Only ratio or length coordinates
#lq.diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  lq.rect(20%, 20%, width: 60%, height: 60%),
  lq.rect(50%, 20%, width: 60%, height: 10%, align: bottom),
  lq.rect(3cm, 2cm, width: 1cm, height: 1cm),
  lq.rect(3cm, 2cm, width: 1cm, height: 1cm, align: right),
)

#pagebreak()

// Mixed coordinates
#lq.diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  lq.rect(40%, 20%, width: 1cm, height: 1cm),
  lq.rect(40%, 20%, width: 1cm, height: 1cm, align: right + top),
  lq.rect(1cm, 1cm, width: -10%, height: 60%),
  lq.rect(2, 1, width: 1cm, height: 1cm),
  lq.rect(2, 1, width: 1cm, height: 1cm, align: right),
)

#pagebreak()

// Datetime coordinates and duration dimensions
#lq.diagram(
  xlim: (
    datetime(year: 0, month: 1, day: 2),
    datetime(year: 0, month: 1, day: 5),
  ),
  ylim: (
    datetime(year: 0, month: 1, day: 1),
    datetime(year: 0, month: 1, day: 5),
  ),
  lq.rect(
    datetime(year: 0, month: 1, day: 3),
    datetime(year: 0, month: 1, day: 2),
    width: duration(hours: 24),
    height: duration(hours: 48),
  ),
)
