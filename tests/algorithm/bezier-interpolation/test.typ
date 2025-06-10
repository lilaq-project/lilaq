#import "/src/algorithm/bezier-interpolation.typ": bezier-splines
#import "/src/assertations.typ": approx

assert-panic(() => bezier-splines((0,), (1,)))
assert-panic(() => bezier-splines((0, 1), (1, 2)))

#let x = range(5)
#let y = range(5).map(y => 3 * y)
#let points = bezier-splines(x, y)
#for point in points {
  approx(3 * point.at(0), point.at(1), eps: 1e-15)
}
