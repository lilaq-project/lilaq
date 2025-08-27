#import "/src/lilaq.typ" as lq
#import "/src/logic/time.typ"



#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2000, month: 1, day: 7),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 1, day: 3),
    datetime(year: 2000, month: 1, day: 4),
    datetime(year: 2000, month: 1, day: 5),
    datetime(year: 2000, month: 1, day: 6),
    datetime(year: 2000, month: 1, day: 7),
  ),
)

#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 28),
      datetime(year: 2000, month: 2, day: 5),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 1, day: 29),
    // datetime(year: 2000, month: 1, day: 31), // not this one!
    datetime(year: 2000, month: 2, day: 1),
    datetime(year: 2000, month: 2, day: 3),
    datetime(year: 2000, month: 2, day: 5),
  ),
)

#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2000, month: 2, day: 27),
      datetime(year: 2000, month: 3, day: 5),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 2, day: 27),
    // datetime(year: 2000, month: 2, day: 29), // not this one!
    datetime(year: 2000, month: 3, day: 1),
    datetime(year: 2000, month: 3, day: 3),
    datetime(year: 2000, month: 3, day: 5),
  ),
)

#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 16),
      datetime(year: 2000, month: 2, day: 5),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 1, day: 16),
    // datetime(year: 2000, month: 1, day: 31), // not this one!
    datetime(year: 2000, month: 1, day: 21),
    datetime(year: 2000, month: 1, day: 26),
    datetime(year: 2000, month: 2, day: 1),
  ),
)

0,4,8,12,16,20,24,28,32
1,5,9,13,17,21,25,29,33

#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2025, month: 8, day: 11),
      datetime(year: 2025, month: 8, day: 19),
    ),
    filter: date => calc.odd(date.day()),
  ).ticks,
  time.to-seconds(
    datetime(year: 2025, month: 8, day: 11),
    datetime(year: 2025, month: 8, day: 13),
    datetime(year: 2025, month: 8, day: 15),
    datetime(year: 2025, month: 8, day: 17),
    datetime(year: 2025, month: 8, day: 19),
  ),
)
#assert.eq(
  lq.tick-locate.days(
    ..time.to-seconds(
      datetime(year: 2025, month: 8, day: 11),
      datetime(year: 2025, month: 8, day: 19),
    ),
    filter: date => date.weekday() in (1, 3, 5),
  ).ticks,
  time.to-seconds(
    datetime(year: 2025, month: 8, day: 11), // Mon
    datetime(year: 2025, month: 8, day: 13), // Wed
    datetime(year: 2025, month: 8, day: 15), // Fr
    datetime(year: 2025, month: 8, day: 18), // Mo
  ),
)
