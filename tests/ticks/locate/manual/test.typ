#import "/src/lilaq.typ" as lq

#assert.eq(
  lq.tick-locate.manual(2, 200, ticks: (3, 4, 5, 6)), 
  (ticks: (3, 4, 5, 6))
)

#assert.eq(
  lq.tick-locate.manual(2, 4, ticks: (3, 1, 4, 5, 6)), 
  (ticks: (3, 4))
)

#assert.eq(
  lq.tick-locate.manual(
    2, 4, 
    ticks: ((2.5, "Label1"), (3.5, "Label2"), (4.5, "Label3"))
  ), 
  (
    ticks: (2.5, 3.5),
    labels: ("Label1", "Label2")
  )
)