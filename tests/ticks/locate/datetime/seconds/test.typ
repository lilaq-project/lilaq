#import "/src/algorithm/ticking.typ": *



#assert.eq(
  locate-seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 0, minute: 1, second: 0),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 0, minute: 0, second: 15),
      datetime(hour: 0, minute: 0, second: 30),
      datetime(hour: 0, minute: 0, second: 45),
      datetime(hour: 0, minute: 1, second: 0),
    ),
    mode: "time",
  ),
)


#assert.eq(
  locate-seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 30, second: 40),
      datetime(hour: 0, minute: 31, second: 0),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(hour: 0, minute: 30, second: 40),
      datetime(hour: 0, minute: 30, second: 45),
      datetime(hour: 0, minute: 30, second: 50),
      datetime(hour: 0, minute: 30, second: 55),
      datetime(hour: 0, minute: 31, second: 0),
    ),
    mode: "time",
  ),
)

#assert.eq(
  locate-seconds(
    ..time.to-seconds(
      datetime(hour: 11, minute: 0, second: 58),
      datetime(hour: 11, minute: 1, second: 0),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(hour: 11, minute: 0, second: 58),
      datetime(hour: 11, minute: 0, second: 59),
      datetime(hour: 11, minute: 1, second: 0),
    ),
    mode: "time",
  ),
)

#assert.eq(
  locate-seconds(
    ..time.to-seconds(
      datetime(hour: 9, minute: 0, second: 0),
      datetime(hour: 9, minute: 5, second: 0),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(hour: 9, minute: 0, second: 0),
      datetime(hour: 9, minute: 1, second: 0),
      datetime(hour: 9, minute: 2, second: 0),
      datetime(hour: 9, minute: 3, second: 0),
      datetime(hour: 9, minute: 4, second: 0),
      datetime(hour: 9, minute: 5, second: 0),
    ),
    mode: "time",
  ),
)


#assert.eq(
  locate-seconds(
    ..time.to-seconds(
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 58, second: 23),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 1, second: 1),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 58, second: 30),
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 59, second: 0),
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 59, second: 30),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 0),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 30),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 1, second: 0),
    ),
    mode: "time",
  ),
)
