#import "/src/algorithm/ticking.typ": *
#import "/src/assertations.typ"


#assertations.approx(
  locate-ticks-log(1, 1000).ticks, 
  (1, 10, 100, 1000)
)

#assertations.approx(
  locate-ticks-log(1, 1e8).ticks, 
  (1, 100, 1e4, 1e6, 1e8)
)

#assertations.approx(
  locate-ticks-log(0.24, 9, base: 2).ticks, 
  (.25, .5, 1, 2, 4, 8)
)

#assertations.approx(
  locate-ticks-log(1, 1024, base: 2).ticks, 
  (1, 4, 16, 64, 256, 1024)
)

#assertations.approx(
  locate-ticks-log(1, 2).ticks, 
  locate-ticks-linear(1, 2).ticks
)

#assertations.approx(
  locate-ticks-log(1, 2, base: 2).ticks, 
  locate-ticks-linear(1, 2).ticks
)

