#import "/src/algorithm/ticking.typ": *
#import "/src/assertations.typ"


#assertations.approx(
  locate-ticks-symlog(1, 1000).ticks, 
  (1, 10, 100, 1000)
)

#assertations.approx(
  locate-ticks-symlog(-100, -1).ticks, 
  (-100, -10, -1)
)

#assertations.approx(
  locate-ticks-symlog(-1, 1).ticks, 
  (-.5, 0, .5)
)