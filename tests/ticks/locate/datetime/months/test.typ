#import "/src/lilaq.typ" as lq
#import "/src/logic/time.typ"


#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2000, month: 11, day: 3),
    ),
    num-ticks-suggestion: 5,
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 8, day: 1),
    datetime(year: 2000, month: 9, day: 1),
    datetime(year: 2000, month: 10, day: 1),
    datetime(year: 2000, month: 11, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2000, month: 11, day: 3),
    ),
    num-ticks-suggestion: 2,
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 9, day: 1),
    datetime(year: 2000, month: 11, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2001, month: 3, day: 3),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 9, day: 1),
    datetime(year: 2000, month: 11, day: 1),
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2001, month: 3, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2001, month: 9, day: 3),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 10, day: 1),
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2001, month: 4, day: 1),
    datetime(year: 2001, month: 7, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2001, month: 12, day: 3),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 10, day: 1),
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2001, month: 4, day: 1),
    datetime(year: 2001, month: 7, day: 1),
    datetime(year: 2001, month: 10, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2001, month: 12, day: 3),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 7, day: 1),
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2001, month: 7, day: 1),
  ),
)



#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2000, month: 12, day: 3),
    ),
    steps: (2,),
    num-ticks-suggestion: 20
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 3, day: 1),
    datetime(year: 2000, month: 5, day: 1),
    datetime(year: 2000, month: 7, day: 1),
    datetime(year: 2000, month: 9, day: 1),
    datetime(year: 2000, month: 11, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.months(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2000, month: 12, day: 3),
    ),
    steps: (1,),
    filter: datetime => datetime.month() in (1, 5, 6)
  ).ticks,
  time.to-seconds(
    datetime(year: 2000, month: 5, day: 1),
    datetime(year: 2000, month: 6, day: 1),
  ),
)
