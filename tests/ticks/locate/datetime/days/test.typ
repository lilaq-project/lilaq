#import "/src/algorithm/ticking.typ": *



#assert.eq(
  locate-days(
    ..time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2000, month: 1, day: 7),
    ),
  ),
  (
    ticks: time.to-seconds(
      datetime(year: 2000, month: 1, day: 3),
      datetime(year: 2000, month: 1, day: 4),
      datetime(year: 2000, month: 1, day: 5),
      datetime(year: 2000, month: 1, day: 6),
      datetime(year: 2000, month: 1, day: 7),
    ),
    mode: "date",
  ),
)

#assert.eq(
  locate-days(
    ..time.to-seconds(
      datetime(year: 2025, month: 8, day: 11),
      datetime(year: 2025, month: 8, day: 19),
    ),
    filter: date => calc.odd(date.day()),
  ),
  (
    ticks: time.to-seconds(
      datetime(year: 2025, month: 8, day: 11),
      datetime(year: 2025, month: 8, day: 13),
      datetime(year: 2025, month: 8, day: 15),
      datetime(year: 2025, month: 8, day: 17),
      datetime(year: 2025, month: 8, day: 19),
    ),
    mode: "date",
  ),
)
#assert.eq(
  locate-days(
    ..time.to-seconds(
      datetime(year: 2025, month: 8, day: 11),
      datetime(year: 2025, month: 8, day: 19),
    ),
    filter: date => date.weekday() in (1, 3, 5),
  ),
  (
    ticks: time.to-seconds(
      datetime(year: 2025, month: 8, day: 11), // Mon
      datetime(year: 2025, month: 8, day: 13), // Wed
      datetime(year: 2025, month: 8, day: 15), // Fr
      datetime(year: 2025, month: 8, day: 18), // Mo
    ),
    mode: "date",
  ),
)
