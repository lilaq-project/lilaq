#import "/src/algorithm/ticking.typ": *




#assert.eq(
  locate-minutes(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 1, minute: 0, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 0, second: 0),
    datetime(hour: 0, minute: 15, second: 0),
    datetime(hour: 0, minute: 30, second: 0),
    datetime(hour: 0, minute: 45, second: 0),
    datetime(hour: 1, minute: 0, second: 0),
  ),
)


#assert.eq(
  locate-minutes(
    ..time.to-seconds(
      datetime(hour: 0, minute: 40, second: 0),
      datetime(hour: 1, minute: 0, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 40, second: 0),
    datetime(hour: 0, minute: 45, second: 0),
    datetime(hour: 0, minute: 50, second: 0),
    datetime(hour: 0, minute: 55, second: 0),
    datetime(hour: 1, minute: 0, second: 0),
  ),
)

#assert.eq(
  locate-minutes(
    ..time.to-seconds(
      datetime(hour: 0, minute: 58, second: 0),
      datetime(hour: 1, minute: 0, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 58, second: 0),
    datetime(hour: 0, minute: 59, second: 0),
    datetime(hour: 1, minute: 0, second: 0),
  ),
)

#assert.eq(
  locate-minutes(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 5, minute: 0, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 0, second: 0),
    datetime(hour: 1, minute: 0, second: 0),
    datetime(hour: 2, minute: 0, second: 0),
    datetime(hour: 3, minute: 0, second: 0),
    datetime(hour: 4, minute: 0, second: 0),
    datetime(hour: 5, minute: 0, second: 0),
  ),
)


#assert.eq(
  locate-minutes(
    ..time.to-seconds(
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 20, second: 23),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 21, second: 45),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 30, second: 0),
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 45, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 15, second: 0),
  ),
)
