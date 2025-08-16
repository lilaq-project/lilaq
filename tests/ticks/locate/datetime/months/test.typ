#import "/src/algorithm/ticking.typ": *

#assert.eq(
  locate-months(
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
  locate-months(
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
  locate-months(
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
  locate-months(
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
  locate-months(
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
  locate-months(
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
