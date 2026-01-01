#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal
#import "@preview/tiptoe:0.4.0"


// Only data coordinates
#lq.diagram(
  xlim: (0.5, 4),
  ylim: (0, 3),
  lq.line((1, 1), (2, 2)),
  lq.line((1.5, 1), (2.5, 2), stroke: red + 2pt),
  lq.line((2, 1), (3, 2), tip: tiptoe.stealth, toe: tiptoe.bar),
  lq.line(
    (2.5, 1),
    (3.5, 2),
    tip: tiptoe.stealth,
    toe: tiptoe.square,
    stroke: red,
  ),
)

#pagebreak()

// nonlinear scale
#lq.diagram(
  xscale: "log",
  yscale: "log",
  xlim: (1, 3),
  ylim: (1, 3),
  lq.line((1, 1), (2, 2)),
)

#pagebreak()

// Only ratio or length coordinates
#lq.diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  lq.line((20%, 20%), (80%, 80%), tip: tiptoe.circle),
  lq.line((1cm, 2cm), (1cm, 1cm), tip: tiptoe.stealth),
)

#pagebreak()

// Mixed coordinates
#lq.diagram(
  xlim: (0, 3),
  ylim: (0, 3),
  lq.line((1cm, 1cm), (50%, 50%)),
  lq.line((1, 1), (1cm, 1cm), tip: tiptoe.stealth),
  lq.line((1, 1), (50%, 50%), tip: tiptoe.stealth),
  lq.line((2, 100%), (3, 50%)),
  lq.line((0cm, 100%), (3, 50%)),
)

#pagebreak()

// Datetime coordinates
#lq.diagram(
  xlim: (
    datetime(year: 0, month: 1, day: 2),
    datetime(year: 0, month: 1, day: 5),
  ),
  ylim: (
    datetime(year: 0, month: 1, day: 1),
    datetime(year: 0, month: 1, day: 5),
  ),
  lq.line(
    (
      datetime(year: 0, month: 1, day: 3),
      datetime(year: 0, month: 1, day: 2),
    ),
    (
      datetime(year: 0, month: 1, day: 4),
      datetime(year: 0, month: 1, day: 3),
    ),
    tip: tiptoe.stealth,
  ),
)
