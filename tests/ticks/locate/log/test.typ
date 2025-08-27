#import "/src/lilaq.typ" as lq
#import "/src/assertations.typ"


#assertations.approx(
  lq.tick-locate.log(1, 1000).ticks, 
  (1, 10, 100, 1000)
)

#assertations.approx(
  lq.tick-locate.log(1, 1e8).ticks, 
  (1, 100, 1e4, 1e6, 1e8)
)

#assertations.approx(
  lq.tick-locate.log(0.24, 9, base: 2).ticks, 
  (.25, .5, 1, 2, 4, 8)
)

#assertations.approx(
  lq.tick-locate.log(1, 1024, base: 2).ticks, 
  (1, 4, 16, 64, 256, 1024)
)

#assertations.approx(
  lq.tick-locate.log(1, 2).ticks, 
  lq.tick-locate.linear(1, 2).ticks
)

#assertations.approx(
  lq.tick-locate.log(1, 2, base: 2).ticks, 
  lq.tick-locate.linear(1, 2).ticks
)

