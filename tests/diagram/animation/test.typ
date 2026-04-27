
#set page(width: auto, height: auto, margin: 1pt)

#import "../../plot/template.typ": *
#show: lq.set-legend(stroke: none)
#show: minimal


#lq.diagram(
  reveal: 1,
  lq.plot((1, 2), (2, 3), label: [A]),
  lq.plot((1, 4), (2, 3), label: [B]),
  lq.plot((1, 4), (2, 1), label: [C]),
)

#lq.diagram(
  reveal: 2,
  lq.plot((1, 2), (2, 3), label: [A]),
  lq.plot((1, 4), (2, 3), label: [B]),
  lq.plot((1, 4), (2, 1), label: [C]),
)

#lq.diagram(
  reveal: 3,
  lq.plot((1, 2), (2, 3), label: [A]),
  lq.plot((1, 4), (2, 3), label: [B]),
  lq.plot((1, 4), (2, 1), label: [C]),
)

#pagebreak()


#let xs = range(4)
#let ys1 = (1.35, 3, 2.1, 4)
#let ys2 = (1.4, 3.3, 1.9, 4.2)
#let yerr1 = (0.2, 0.3, 0.5, 0.4)
#let yerr2 = (0.3, 0.3, 0.4, 0.7)
#let t = lq.diagram.with(
  width: 5cm,
  legend: (position: left + bottom),

  lq.bar(xs, ys1, offset: -0.2, width: 0.4, label: [Left]),
  lq.bar(xs, ys2, offset: 0.2, width: 0.4, label: [Right]),

  lq.plot(
    xs.map(x => x - 0.2),
    ys1,
    yerr: yerr1,
    color: black,
    stroke: none,
  ),
  lq.plot(
    xs.map(x => x + 0.2),
    ys2,
    yerr: yerr2,
    color: black,
    stroke: none,
  ),
)
#t(
  reveal: i => {
    calc.rem(i, 2) < 1
  },
)

#t(
  reveal: i => {
    calc.rem(i, 2) < 2
  },
)