#import "/src/lilaq.typ" as lq


#let curve = lq.plot-function(
  (-2, 2),
  x => x * x,
  samples: 5,
)

#assert.eq(curve.x, (-2, -1, 0, 1, 2))
#assert.eq(curve.y, (4, 1, 0, 1, 4))
#assert.eq(curve.mark.mark, none)
#assert.eq(curve.style.smooth, true)
#assert.eq((curve.xlimits)(), (-2, 2))
#assert.eq((curve.ylimits)(), (0, 4))


#let styled = lq.plot-function(
  (0, calc.pi),
  calc.sin,
  samples: 3,
  mark: "o",
  smooth: false,
  color: red,
  label: [Sine],
)

#assert.eq(styled.x, (0, calc.pi / 2, calc.pi))
#assert.eq(styled.mark.mark, "o")
#assert.eq(styled.style.smooth, false)
#assert.eq(styled.style.color, red)
#assert.eq(styled.label, [Sine])


#let default = lq.plot-function((1, 3), x => x)
#assert.eq(default.x.len(), 200)
#assert.eq(default.x.first(), 1)
#assert.eq(default.x.last(), 3)


#assert-panic(() => lq.plot-function((0,), x => x))
#assert-panic(() => lq.plot-function((0, 1), 1))
#assert-panic(() => lq.plot-function((0, 1), x => x, samples: 1))
