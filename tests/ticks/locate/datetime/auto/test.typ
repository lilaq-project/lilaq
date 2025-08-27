#import "/src/lilaq.typ" as lq
#import "/src/logic/time.typ"

#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 1, day: 1),
      datetime(year: 1975, month: 1, day: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1970, month: 1, day: 1),
    datetime(year: 1971, month: 1, day: 1),
    datetime(year: 1972, month: 1, day: 1),
    datetime(year: 1973, month: 1, day: 1),
    datetime(year: 1974, month: 1, day: 1),
    datetime(year: 1975, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 2, day: 1),
      datetime(year: 1975, month: 1, day: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1971, month: 1, day: 1),
    datetime(year: 1972, month: 1, day: 1),
    datetime(year: 1973, month: 1, day: 1),
    datetime(year: 1974, month: 1, day: 1),
    datetime(year: 1975, month: 1, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 1, day: 1),
      datetime(year: 1975, month: 1, day: 1),
    ),
    num-ticks-suggestion: 11,
  ).ticks,
  time.to-seconds(
    datetime(year: 1970, month: 1, day: 1),
    datetime(year: 1970, month: 7, day: 1),
    datetime(year: 1971, month: 1, day: 1),
    datetime(year: 1971, month: 7, day: 1),
    datetime(year: 1972, month: 1, day: 1),
    datetime(year: 1972, month: 7, day: 1),
    datetime(year: 1973, month: 1, day: 1),
    datetime(year: 1973, month: 7, day: 1),
    datetime(year: 1974, month: 1, day: 1),
    datetime(year: 1974, month: 7, day: 1),
    datetime(year: 1975, month: 1, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 6, day: 1),
      datetime(year: 1973, month: 1, day: 2),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1970, month: 7, day: 1),
    datetime(year: 1971, month: 1, day: 1),
    datetime(year: 1971, month: 7, day: 1),
    datetime(year: 1972, month: 1, day: 1),
    datetime(year: 1972, month: 7, day: 1),
    datetime(year: 1973, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 1, day: 1),
      datetime(year: 1971, month: 1, day: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1970, month: 1, day: 1),
    datetime(year: 1970, month: 4, day: 1),
    datetime(year: 1970, month: 7, day: 1),
    datetime(year: 1970, month: 10, day: 1),
    datetime(year: 1971, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1970, month: 1, day: 1),
      datetime(year: 1971, month: 1, day: 1),
    ),
    num-ticks-suggestion: 3,
  ).ticks,
  time.to-seconds(
    datetime(year: 1970, month: 1, day: 1),
    datetime(year: 1970, month: 7, day: 1),
    datetime(year: 1971, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1969, month: 11, day: 2),
      datetime(year: 1970, month: 5, day: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1969, month: 12, day: 1),
    datetime(year: 1970, month: 1, day: 1),
    datetime(year: 1970, month: 2, day: 1),
    datetime(year: 1970, month: 3, day: 1),
    datetime(year: 1970, month: 4, day: 1),
    datetime(year: 1970, month: 5, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1969, month: 11, day: 2),
      datetime(year: 1970, month: 1, day: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1969, month: 11, day: 15),
    datetime(year: 1969, month: 12, day: 1),
    datetime(year: 1969, month: 12, day: 15),
    datetime(year: 1970, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1969, month: 11, day: 2),
      datetime(year: 1970, month: 1, day: 1),
    ),
    num-ticks-suggestion: 6,
  ).ticks,
  time.to-seconds(
    datetime(year: 1969, month: 11, day: 8),
    datetime(year: 1969, month: 11, day: 15),
    datetime(year: 1969, month: 11, day: 22),
    datetime(year: 1969, month: 12, day: 1),
    datetime(year: 1969, month: 12, day: 8),
    datetime(year: 1969, month: 12, day: 15),
    datetime(year: 1969, month: 12, day: 22),
    datetime(year: 1970, month: 1, day: 1),
  ),
)
#assert.eq(
  lq.tick-locate.datetime(
    ..time.to-seconds(
      datetime(year: 1969, month: 11, day: 2),
      datetime(year: 1970, month: 1, day: 1),
    ),
    num-ticks-suggestion: 12,
  ).ticks,
  time.to-seconds(
    datetime(year: 1969, month: 11, day: 6),
    datetime(year: 1969, month: 11, day: 11),
    datetime(year: 1969, month: 11, day: 16),
    datetime(year: 1969, month: 11, day: 21),
    datetime(year: 1969, month: 11, day: 26),
    datetime(year: 1969, month: 12, day: 1),
    datetime(year: 1969, month: 12, day: 6),
    datetime(year: 1969, month: 12, day: 11),
    datetime(year: 1969, month: 12, day: 16),
    datetime(year: 1969, month: 12, day: 21),
    datetime(year: 1969, month: 12, day: 26),
    datetime(year: 1970, month: 1, day: 1),
  ),
)
