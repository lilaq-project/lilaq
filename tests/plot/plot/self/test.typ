#set page(width: auto, height: auto, margin: 1pt)

#import "../../template.typ": *
#show: minimal


#let plot = lq.plot.with(label: [])
#show lq.selector(lq.legend): set grid(columns: 4)


// Cycling test
#lq.diagram(
  cycle: (
    it => {
      set lq.style(fill: blue)
      it
    },
    it => {
      set lq.style(fill: red)
      it
    },
    it => {
      set lq.style(fill: red, stroke: green)
      it
    },
    it => {
      set lq.style(fill: orange)
      set lq.mark(fill: yellow)
      it
    },
    it => {
      set lq.style(fill: purple.lighten(60%))
      set lq.mark(fill: yellow, stroke: black)
      it
    },
  ),
  plot((1, 2, 3), (6,) * 3),
  plot((1, 2, 3), (5,) * 3),
  plot((1, 2, 3), (4,) * 3),
  plot((1, 2, 3), (3,) * 3),
  plot((1, 2, 3), (2,) * 3),
  plot((1, 2, 3), (1,) * 3, color: green),
  plot((1, 2, 3), (0,) * 3, stroke: green),
  plot((1, 2, 3), (-1,) * 3, color: blue),
  plot((1, 2, 3), (-2,) * 3, stroke: green),
  plot((1, 2, 3), (-3,) * 3, color: green),
)



#pagebreak()


// Step
#lq.diagram(
  lq.plot(
    (1, 2, 3),
    (2.1, 2.4, 2.1),
    step: start,
  ),
  lq.plot(
    (1, 2, 3),
    (1.1, 1.4, 1.1),
    step: center,
  ),
  lq.plot(
    (1, 2, 3),
    (.1, .4, .1),
    step: end,
  ),
)


#pagebreak()


#let x = range(20)
#let y = (0,) * x.len()

// Every
#lq.diagram(
  lq.plot(x, y.map(y => y + 6), every: none),
  lq.plot(x, y.map(y => y + 5), every: 2),
  lq.plot(x, y.map(y => y + 4), every: (n: 2, start: 1)),
  lq.plot(x, y.map(y => y + 3), every: (n: 2, start: 3, end: -1)),
  lq.plot(x, y.map(y => y + 2), every: 3),
  lq.plot(x, y.map(y => y + 1), every: (0, 10, 15, 19)),
  lq.plot(x, y.map(y => y + 0), yerr: .3, every: 4),
)


#pagebreak()


// Clipping
#page(
  margin: 5pt,
  lq.diagram(
    width: 1cm,
    height: .5cm,
    margin: 0%,
    lq.plot((0, 1), (0, 0)),
    lq.plot((0, 1), (1, 1), clip: false),
  ),
)


#pagebreak()


// Z-index
#lq.diagram(
  height: 1cm,
  lq.plot((0, 1, 2), (0, 1, 2)),
  lq.plot((0, 1, 2), (2, 1, 0), z-index: 1),
  lq.plot((0, 1, 2), (2, 1.5, 2)),
)


#pagebreak()



// Errors
#let errors = lq.diagram(
  lq.plot((0, 1, 2), (3,) * 3, yerr: .4),
  lq.plot((0, 1, 2), (2,) * 3, xerr: .3, stroke: none),
  lq.plot(
    (0, 1, 2),
    (1,) * 3,
    xerr: (.4, .2, .3),
    yerr: (.4, .2, .3),
    stroke: none,
  ),
  lq.plot(
    (0, 1, 2),
    (0,) * 3,
    xerr: (p: .1, m: .2),
    yerr: (p: .1, m: .2),
    stroke: none,
  ),
  lq.plot(
    (0, 1, 2),
    (-1,) * 3,
    xerr: (p: (.1, .2, .3), m: .2),
    yerr: (p: .1, m: (.4, .3, .2)),
    stroke: none,
  ),
)

#box(errors)
#{
  show: lq.set-diagram(
    xaxis: (inverted: true),
    yaxis: (inverted: true),
  )
  box(errors)
}



#pagebreak()



// Mark
#lq.diagram(
  height: 1cm,
  cycle: (
    (mark: "+"),
    (mark: "x"),
  ),
  lq.plot((0,), (0,)),
  lq.plot((1,), (0,)),
  lq.plot((2,), (0,), mark: "s"),
  lq.plot((3,), (0,), mark: lq.marks.at("*")),
  lq.plot((4,), (0,), mark-size: 2pt),
)



#pagebreak()


// Interrupt at nan
#lq.diagram(
  lq.plot(
    range(8),
    (1, 2, 3, float.nan, 6, 4, float.nan, 3),
  ),
)


#pagebreak()


#let x = range(3) + (float.nan, 3, 4, float.nan, 5)
#let y = (2, -1, 3, float.nan, 2, 0, float.nan, 1)

// Smooth
#lq.diagram(
  lq.plot(x, y, smooth: false),
  lq.plot(x, y, smooth: true),
)

// #assert.eq(
//   catch(() => lq.plot((), (), smooth: true, step: end)),
//   "panicked with: \"`step` and `smooth` are mututally exclusive\""
// )


#pagebreak()

// Plot-Fn
#lq.diagram(
  lq.plot(lq.linspace(-1, 1), x => calc.max(0, x)),
)




#pagebreak()

#import "@preview/tiptoe:0.4.0"
// arrow tips and toes
#lq.diagram(
  lq.plot(
    range(8),
    (0, 0.84, 0.90, 0.14, float.nan, -0.95, -0.27, 0.656),
    tip: tiptoe.triangle,
  ),
  lq.plot(
    range(8),
    (1, float.nan, 3, 2, 6, 4, float.nan, 3),
    tip: tiptoe.stealth,
    toe: tiptoe.triangle,
  ),
)
