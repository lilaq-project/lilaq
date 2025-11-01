#set page(width: auto, height: auto, margin: 5pt)

#import "/src/math.typ": *


#assert.eq(cmin((1,2,3,4)), 1)
#assert.eq(cmin((1,2,3,-23.2)), -23.2)
#assert.eq(cmin((float.nan,2,3,-23.2)), -23.2)
#assert.eq(cmin((float.nan,)), none)
#assert.eq(cmax((1,2,3,4)), 4)
#assert.eq(cmax((-1,-2,-3,-23.2)), -1)
#assert.eq(cmax((float.nan,2,3,-23.2)), 3)
#assert.eq(cmax((float.nan,)), none)

#assert.eq(float.is-nan(float.nan), true)
#assert.eq(float.is-nan(1e123), false)
#assert.eq(float.is-nan(0), false)
#assert.eq(float.is-nan(-1232445345345e200000000000000000), false)



// Special cases: num = 0,1
#assert.eq(linspace(0, 1, num: 0), ())
#assert.eq(linspace(0, 1, num: 0, include-end: false), ())
#assert.eq(linspace(-2.3, 1, num: 1), (-2.3, ))
#assert.eq(linspace(-2.3, 1, num: 1, include-end: false), (-2.3, ))

// Normal operation
#assert.eq(linspace(0, 1, num: 2), (0, 1))
#assert.eq(linspace(0, 1, num: 2, include-end: false), (0, .5))
#assert.eq(linspace(-3.4, 7, num: 2), (-3.4, 7))
#assert.eq(linspace(-3, 7, num: 2, include-end: false), (-3, 2))
#assert.eq(linspace(0, 1, num: 5), (0, .25, .5, .75, 1))

// Inverse range
#assert.eq(linspace(1, 0, num: 2), (1, 0))
#assert.eq(linspace(100, 0, num: 2), (100, 0))
#assert.eq(linspace(100, 0, num: 2, include-end: false), (100, 50))


#assert.eq(arange(0, 1), (0,))
#assert.eq(arange(0, 2), (0,1))
#assert.eq(arange(0, 1, step: 0.25), (0,.25, .5, .75))
#assert.eq(arange(0, 2, step: 0.25), (0,.25, .5, .75, 1, 1.25, 1.5, 1.75))

// Inverse range
#assert.eq(arange(1, 0), ())
#assert.eq(arange(41, 0), ())
#assert.eq(arange(1, 0, step: -1), (1,))
#assert.eq(arange(0, -4, step: -1), (0, -1, -2, -3))
#assert.eq(arange(1, 0, step: -0.25), (1,.75, .5, .25))





#assert.eq(percentile((1,2,3), 50%), 2)
#assert.eq(percentile((1,2,3), 25%), 1.5)
#assert.eq(percentile((1,2,3), 0%), 1)
#assert.eq(percentile((1,2,3), 100%), 3)



#assert.eq(
  mesh((0, 2), (4, 5), (x, y) => (x + y/10)),
  ((0.4, 2.4), (0.5, 2.5))
)

#assert.eq(
  mesh((0, 2), (4, 5), (x, y) => (x + y/10), (x, y) => (x - y)),
  (
    ((0.4, 2.4), (0.5, 2.5)),
    ((-4, -2), (-5, -3)),
  )
)



#assert.eq(divmod(5, 2), (2, 1))
#assert.eq(divmod(5, .5), (10, 0))
#assert.eq(divmod(5.25, .5), (10, 0.25))
#assert.eq(divmod(5.25, -.5), (-11, -0.25))
#assert.eq(divmod(5.25, -.5), (-11, -0.25))
#assert.eq(divmod(-5.25, .5), (-11, 0.25))
#assert.eq(divmod(-5.25, -.5), (10, -0.25))
#assert.eq(divmod(2, 1), (2, 0))
#assert.eq(divmod(-2, 1), (-2, 0))
#assert.eq(divmod(1, .2), (5, 0))
#assert.eq(divmod(5, .2), (25, 0))


#{
  let check(x, d) = {
    let quo = calc.div-euclid(x, d)
    let rem = calc.rem(x, d)
    let (quo, rem) = divmod(x, d)
    assert.eq(quo*d + rem, x)
  }
  check(5, -.2)
  check(2, 1)
  check(-2, 1)
  check(1, .2)
  check(-5, .2)
  check(-5, -.2)
  check(115, 22)
  check(115, .22)
  check(1e30, 1e20)
}

