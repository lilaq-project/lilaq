#import "/src/lilaq.typ" as lq
#import "/src/assertations.typ"


#assert.eq(
  lq.tick-locate.subticks-log(1, 10, ticks: ()).ticks, 
  ()
)

#assert.eq(
  lq.tick-locate.subticks-log(1, 10, ticks: (3,)).ticks, 
  ()
)

#assert.eq(
  lq.tick-locate.subticks-log(1, 10, ticks: (1, 10)).ticks, 
  range(2, 10)
)

#assertations.approx(
  lq.tick-locate.subticks-log(.25, 20, ticks: (1, 10)).ticks, 
  range(3, 10).map(x=>x/10) + range(2, 10) + (20,)
)
