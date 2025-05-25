#import "/src/algorithm/ticking.typ": *
#import "/src/assertations.typ"



#assertations.approx(
  locate-subticks-linear(1, 2, ticks: (), num: 1).ticks, 
  ()
)

#assertations.approx(
  locate-subticks-linear(1, 2, ticks: (1,), num: 1).ticks, 
  ()
)

#assertations.approx(
  locate-subticks-linear(1, 2, ticks: (1, 2), num: 1).ticks, 
  (1.5,)
)

#assertations.approx(
  locate-subticks-linear(2, 1, ticks: (1, 2), num: 1).ticks, 
  (1.5,)
)

#assertations.approx(
  locate-subticks-linear(1, 2, ticks: (1, 2), num: 3).ticks, 
  (1.25,1.5,1.75)
)

#assertations.approx(
  locate-subticks-linear(0, 2, ticks: (1, 2), num: 1).ticks, 
  (0.5, 1.5)
)

// Test for interval enhancement and restriction to [x0, x1]
#assertations.approx(
  locate-subticks-linear(1, 3, ticks: (1, 2), num: 3).ticks, 
  (1.25, 1.5, 1.75, 2.25, 2.5, 2.75)
)

#assertations.approx(
  locate-subticks-linear(1, 2.5, ticks: (1, 2), num: 3).ticks, 
  (1.25, 1.5, 1.75, 2.25, 2.5)
)

#assertations.approx(
  locate-subticks-linear(.5, 1.5, ticks: (1, 2), num: 3).ticks, 
  (0.5, 0.75, 1.25, 1.5)
)

#assertations.approx(
  locate-subticks-linear(.55, 1.5, ticks: (1, 2), num: 3).ticks, 
  (0.75, 1.25, 1.5)
)

#assertations.approx(
  locate-subticks-linear(5, 25, ticks: (11, 21), tick-distance: 10, num: 1).ticks, 
  (6, 16,)
)
