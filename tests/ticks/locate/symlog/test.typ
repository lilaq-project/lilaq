#import "/src/lilaq.typ" as lq
#import "/src/assertations.typ"


#assertations.approx(
  lq.tick-locate.symlog(1, 1000).ticks, 
  (1, 10, 100, 1000)
)

#assertations.approx(
  lq.tick-locate.symlog(-100, -1).ticks, 
  (-100, -10, -1)
)

#assertations.approx(
  lq.tick-locate.symlog(-1, 1).ticks, 
  (-.5, 0, .5)
)