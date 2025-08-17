#import "/src/algorithm/ticking.typ": *



#assert.eq(
  locate-hours(
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
  locate-hours(
    ..time.to-seconds(
      datetime(hour: 2, minute: 0, second: 0),
      datetime(hour: 7, minute: 0, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 2, minute: 0, second: 0),
    datetime(hour: 3, minute: 0, second: 0),
    datetime(hour: 4, minute: 0, second: 0),
    datetime(hour: 5, minute: 0, second: 0),
    datetime(hour: 6, minute: 0, second: 0),
    datetime(hour: 7, minute: 0, second: 0),
  ),
)

#assert.eq(
  locate-hours(
    ..time.to-seconds(
      datetime(year: 1, month: 12, day: 31, hour: 21, minute: 2, second: 23),
      datetime(year: 2, month: 1, day: 1, hour: 2, minute: 21, second: 45),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1, month: 12, day: 31, hour: 22, minute: 0, second: 0),
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 0, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 1, minute: 0, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 2, minute: 0, second: 0),
  ),
)


#assert.eq(
  locate-hours(
    ..time.to-seconds(
      datetime(hour: 2, minute: 0, second: 0),
      datetime(hour: 7, minute: 0, second: 0),
    ),
    steps: (2,)
  ).ticks,
  time.to-seconds(
    datetime(hour: 2, minute: 0, second: 0),
    datetime(hour: 4, minute: 0, second: 0),
    datetime(hour: 6, minute: 0, second: 0),
  ),
)

#assert.eq(
  locate-hours(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 23, minute: 0, second: 0),
    ),
    steps: (1,),
    filter: datetime => datetime.hour() in (5, 12, 18)
  ).ticks,
  time.to-seconds(
    datetime(hour: 5, minute: 0, second: 0),
    datetime(hour: 12, minute: 0, second: 0),
    datetime(hour: 18, minute: 0, second: 0),
  ),
)
