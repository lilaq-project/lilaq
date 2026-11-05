#set page(width: auto, height: auto, margin: 5pt)

#import "/src/lilaq.typ" as lq
#import "/src/model/axis.typ": _axis-compute-limits
#import "/src/assertations.typ": approx

#let axis-limits(data, margin: 6%, ..args) = {
  let axis = lq.axis(lq.plot(data, data), ..args)

  _axis-compute-limits(axis, margin: margin)
}

// Ordinary axes retain their existing automatic limits and margins.
#approx(axis-limits((1, 10)), (.46, 10.54))
#approx(axis-limits((-10, -1)), (-10.54, -.46))

// Include the origin before padding either positive or negative data.
#approx(axis-limits((1, 10), include-zero: true), (-.6, 10.6))
#approx(axis-limits((-10, -1), include-zero: true), (-10.6, .6))
#approx(axis-limits((1, 10), kind: "y", include-zero: true), (-.6, 10.6))
#approx(axis-limits((-10, -1), kind: "y", include-zero: true), (-10.6, .6))

// Data already spanning zero keeps its original limits.
#approx(axis-limits((-3, 7)), (-3.6, 7.6))
#approx(axis-limits((-3, 7), include-zero: true), (-3.6, 7.6))

// Explicit endpoints stay fixed, including partially automatic ranges.
#approx(axis-limits((1, 10), include-zero: true, lim: (2, 8)), (2, 8))
#approx(axis-limits((1, 10), include-zero: true, lim: (2, auto)), (2, 10.48))
#approx(axis-limits((1, 10), include-zero: true, lim: (auto, 8)), (-.48, 8))
#approx(axis-limits((-10, -1), include-zero: true, lim: (auto, -2)), (-10.48, -2))
#approx(axis-limits((-10, -1), include-zero: true, lim: (-8, auto)), (-8, .48))

// Symmetric log axes can include zero; logarithmic axes must remain positive.
#approx(axis-limits((1, 10), scale: "symlog", include-zero: true, margin: 0%), (0, 10))
#approx(axis-limits((-10, -1), scale: "symlog", include-zero: true, margin: 0%), (-10, 0))
#approx(
  axis-limits((1, 10), scale: "log", include-zero: true),
  axis-limits((1, 10), scale: "log"),
)

// Datetime coordinates stay near their dates rather than extending to year zero.
#let dates = (
  datetime(year: 2025, month: 1, day: 1),
  datetime(year: 2025, month: 1, day: 2),
)
#let epoch = datetime(year: 0, month: 1, day: 1)
#let date-limits = dates.map(date => (date - epoch).seconds())
#assert.eq(axis-limits(dates, include-zero: true, margin: 0%), date-limits)
#approx(
  axis-limits(dates, include-zero: true),
  axis-limits(dates),
)

// Exercise the public schoolbook theme in each quadrant for visual regression.
#show: lq.theme.schoolbook
#show: lq.set-diagram(width: 4cm, height: 3cm)

#grid(
  columns: 2,
  gutter: 20pt,
  lq.diagram(lq.plot((1, 10), (1, 10))),
  lq.diagram(lq.plot((-10, -1), (1, 10))),
  lq.diagram(lq.plot((1, 10), (-10, -1))),
  lq.diagram(lq.plot((-10, -1), (-10, -1))),
)
