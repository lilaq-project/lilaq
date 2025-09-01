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

#assert.eq(
  lq.tick-locate.manual(
    0, 10, 
    ticks: (
      datetime(hour: 0, minute: 0, second: 3),
      datetime(hour: 0, minute: 0, second: 4),
    )
  ), 
  (ticks: (3, 4), mode: "time")
)

#assert.eq(
  lq.tick-locate.manual(
    0, 3, 
    ticks: (
      datetime(hour: 0, minute: 0, second: 3),
      datetime(hour: 0, minute: 0, second: 4),
    )
  ), 
  (ticks: (3,), mode: "time")
)

#assert.eq(
  lq.tick-locate.manual(
    0, 10, 
    ticks: (
      datetime(year: 0, month: 1, day: 1, hour: 0, minute: 0, second: 3),
      datetime(year: 0, month: 1, day: 1, hour: 0, minute: 0, second: 4),
    )
  ), 
  (ticks: (3, 4), mode: "datetime")
)

#assert.eq(
  lq.tick-locate.manual(
    0, 10, 
    ticks: (
      datetime(year: 0, month: 1, day: 1),
    )
  ), 
  (ticks: (0,), mode: "date")
)


#assert.eq(
  lq.tick-locate.manual(
    2, 4, 
    ticks: (
      (datetime(hour: 0, minute: 0, second: 3), "A"),
      (datetime(hour: 0, minute: 0, second: 4), "B"),
    )
  ), 
  (
    ticks: (3, 4),
    labels: ("A", "B"),
    mode: "time"
  )
)
