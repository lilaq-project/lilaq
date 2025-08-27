#import "/src/lilaq.typ" as lq
#import "/src/assertations.typ"


#assert.eq(
  lq.tick-locate.linear(0, 1, tick-distance: .25).ticks, 
  (0, 0.25, .5, .75, 1)
)
#assert.eq(
  lq.tick-locate.linear(-4, 19, tick-distance: auto).ticks, 
  (0, 5, 10, 15)
)
#assert.eq(
  lq.tick-locate.linear(-4, 19, tick-distance: 5).ticks, 
  (0, 5, 10, 15)
)


// Selected cases
#assertations.approx(
  lq.tick-locate.linear(0, 0.1).ticks.len(), 6
)
#assertations.approx(
  lq.tick-locate.linear(0, 0.1).ticks, 
  (0, .02, .04, .06, .08, .1)
)
#assertations.approx(
  lq.tick-locate.linear(-200, -199).ticks, 
  (-200, -199.8, -199.6, -199.4, -199.2, -199.0)
)
#assertations.approx(
  lq.tick-locate.linear(115, 116).ticks, 
  (115, 115.2, 115.4, 115.6, 115.8, 116)
)
#assertations.approx(
  lq.tick-locate.linear(-4.2, 20).ticks, 
  (0, 5, 10, 15, 20)
)
#assertations.approx(
  lq.tick-locate.linear(-1, 0).ticks, 
  (-1, -.8, -.6, -.4, -.2, 0)
)
#assertations.approx(
  lq.tick-locate.linear(0, 1).ticks, 
  (0, .2, .4, .6, .8, 1)
)
#assertations.approx(
  lq.tick-locate.linear(0.1, 1.2).ticks, 
  (.2, .4, .6, .8, 1., 1.2)
)
#assertations.approx(
  lq.tick-locate.linear(1.2, 0.1).ticks, 
  (1.2, 1., .8, .6, .4, .2).rev()
)
#assertations.approx(
  lq.tick-locate.linear(1, 20).ticks, 
  (5, 10, 15, 20)
)



// Inverse axes
#assertations.approx(
  lq.tick-locate.linear(1.25, 0.1).ticks, 
  (1.2, 1.0, .8, .6, .4, .2).rev()
)
#assertations.approx(
  lq.tick-locate.linear(1, 0).ticks, 
  (0, .2, .4, .6, .8, 1.)
)
#assertations.approx(
  lq.tick-locate.linear(1.2, 0.1).ticks, 
  (.2, .4, .6, .8, 1, 1.2)
)


// Test negative axes
#assertations.approx(
  lq.tick-locate.linear(-2.2, 20).ticks, 
  (0, 5, 10, 15, 20)
)
#assertations.approx(
  lq.tick-locate.linear(-4.2, -2).ticks, 
  (-4, -3.5, -3, -2.5, -2)
)
#assertations.approx(
  lq.tick-locate.linear(-4.2, 8.1).ticks, 
  (-4, -2, 0, 2, 4, 6, 8)
)
#assertations.approx(
  lq.tick-locate.linear(-116, -115).ticks, 
  (-116, -115.8, -115.6, -115.4, -115.2, -115)
)
#assertations.approx(
  lq.tick-locate.linear(-16, -15).ticks, 
  (-16, -15.8, -15.6, -15.4, -15.2, -15)
)
#assertations.approx(
  lq.tick-locate.linear(-0.000000000000003, 0.0005).ticks, 
  (0, .0001, .0002, .0003, .0004, .0005)
)


// Extreme cases

#assertations.approx(
  lq.tick-locate.linear(100005, 100006).ticks, 
  (100005, 100005.2, 100005.4, 100005.6, 100005.8, 100006)
)
#assertations.approx(
  lq.tick-locate.linear(1e20, 20e20).ticks, 
  (5e20, 10e20, 15e20, 20e20)
)
#assertations.approx(
  lq.tick-locate.linear(1e45, 20e45).ticks, 
  (5e45, 10e45, 15e45, 20e45)
)
#assertations.approx(
  lq.tick-locate.linear(1000000007, 1000000008).ticks, 
  (1000000007, 1000000007.2, 1000000007.4, 1000000007.6, 1000000007.8, 1000000008)
)
#assertations.approx(
  lq.tick-locate.linear(.0000000000000026, .000000000000010).ticks, 
  (.000000000000004, .000000000000006, .000000000000008, .00000000000001)
)
#assertations.approx(
  lq.tick-locate.linear(-2.6e-14, 10e-14).ticks, 
  (-2e-14, 0, 2e-14, 4e-14, 6e-14, 8e-14, 10e-14)
)
#assertations.approx(
  lq.tick-locate.linear(-2.6e304, 10e304).ticks, 
  (-2e304, 0, 2e304, 4e304, 6e304, 8e304, 10e304)
)
#assertations.approx(
  lq.tick-locate.linear(-2.6e-295, 10e-295).ticks, 
  (-2e-295, 0, 2e-295, 4e-295, 6e-295, 8e-295, 10e-295)
)
#assertations.approx(
  lq.tick-locate.linear(-2.6e-15, 8e-14).ticks, 
  (0, 2e-14, 4e-14, 6e-14, 8e-14)
)
#assertations.approx(
  lq.tick-locate.linear(1e-199, 1e199).ticks, 
  (0, 2e198, 4e198, 6e198, 8e198, 10e198)
)
#assertations.approx(
  lq.tick-locate.linear(1e301, 8e307).ticks, 
  (2e307, 4e307, 6e307, 8e307)
)


// Custom unit
#assert.eq(
  lq.tick-locate.linear(0, 7, unit: calc.pi),
  (
    ticks: (0, calc.pi*0.5, calc.pi, calc.pi*1.5, 2*calc.pi),
    offset: 0,
    exponent: 0,
    tick-distance: calc.pi/2,
    unit: calc.pi,
    significant-digits: 1,
  ) 
)

#assert.eq(
  lq.tick-locate.linear(calc.pi*1010, calc.pi*1015, unit: calc.pi).ticks, 
  range(6).map(x => (1010 + x)*calc.pi)
)



// High-precision tests
#assertations.approx(
  lq.tick-locate.linear(181145e-5, 181139e-5, num-ticks-suggestion: 7).ticks,
  (39, 40, 41, 42, 43, 44, 45).map(x => x*1e-5 + 1.811)
)


#assertations.approx(
  lq.tick-locate.linear(123181145e-8, 123181139e-8, num-ticks-suggestion: 7).ticks,
  (39, 40, 41, 42, 43, 44, 45).map(x => x*1e-8 + 1.231811)
)




// Tick-distance min/max
#assert.eq(
  lq.tick-locate.linear(0, 3, tick-distance: (min: 1)).ticks, 
  (0., 1., 2., 3.)
)

#assert.eq(
  lq.tick-locate.linear(0, 5, tick-distance: (max: 0.5)).ticks, 
  (0., 0.5, 1., 1.5, 2., 2.5, 3., 3.5, 4., 4.5, 5.)
)

#assert.eq(
  catch(() => lq.tick-locate.linear(0, 5, tick-distance: ("baa": 2))), 
  "assertion failed: Unexpected key \"baa\" in `tick-distance` (expected \"min\" or/and \"max\")"
)

#assert.eq(
  lq.tick-locate.linear(0, 5, tick-distance: (min: .5, max: 1)).ticks, 
  (0., 1., 2., 3., 4., 5.)
)

#assert.eq(
  catch(() => lq.tick-locate.linear(0, 5, tick-distance: ("baa": 2))), 
  "assertion failed: Unexpected key \"baa\" in `tick-distance` (expected \"min\" or/and \"max\")"
)