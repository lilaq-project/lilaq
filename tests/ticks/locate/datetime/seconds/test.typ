#import "/src/lilaq.typ" as lq
#import "/src/logic/time.typ"



#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 0, minute: 1, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 0, second: 0),
    datetime(hour: 0, minute: 0, second: 15),
    datetime(hour: 0, minute: 0, second: 30),
    datetime(hour: 0, minute: 0, second: 45),
    datetime(hour: 0, minute: 1, second: 0),
  ),
)


#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 30, second: 40),
      datetime(hour: 0, minute: 31, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 30, second: 40),
    datetime(hour: 0, minute: 30, second: 45),
    datetime(hour: 0, minute: 30, second: 50),
    datetime(hour: 0, minute: 30, second: 55),
    datetime(hour: 0, minute: 31, second: 0),
  ),
)

#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 11, minute: 0, second: 58),
      datetime(hour: 11, minute: 1, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 11, minute: 0, second: 58),
    datetime(hour: 11, minute: 0, second: 59),
    datetime(hour: 11, minute: 1, second: 0),
  ),
)

#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 9, minute: 0, second: 0),
      datetime(hour: 9, minute: 5, second: 0),
    ),
  ).ticks,
  time.to-seconds(
    datetime(hour: 9, minute: 0, second: 0),
    datetime(hour: 9, minute: 1, second: 0),
    datetime(hour: 9, minute: 2, second: 0),
    datetime(hour: 9, minute: 3, second: 0),
    datetime(hour: 9, minute: 4, second: 0),
    datetime(hour: 9, minute: 5, second: 0),
  ),
)


#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(year: 1, month: 12, day: 31, hour: 23, minute: 58, second: 23),
      datetime(year: 2, month: 1, day: 1, hour: 0, minute: 1, second: 1),
    ),
  ).ticks,
  time.to-seconds(
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 58, second: 30),
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 59, second: 0),
    datetime(year: 1, month: 12, day: 31, hour: 23, minute: 59, second: 30),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 0),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 0, second: 30),
    datetime(year: 2, month: 1, day: 1, hour: 0, minute: 1, second: 0),
  ),
)


#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 0, minute: 1, second: 30),
    ),
    steps: (13,),
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 0, second: 0),
    datetime(hour: 0, minute: 0, second: 13),
    datetime(hour: 0, minute: 0, second: 26),
    datetime(hour: 0, minute: 0, second: 39),
    datetime(hour: 0, minute: 0, second: 52),
    datetime(hour: 0, minute: 1, second: 5),
    datetime(hour: 0, minute: 1, second: 18),
  ),
)


#assert.eq(
  lq.tick-locate.seconds(
    ..time.to-seconds(
      datetime(hour: 0, minute: 0, second: 0),
      datetime(hour: 0, minute: 1, second: 30),
    ),
    steps: (1,),
    filter: time => time.second() in (2, 22, 42)
  ).ticks,
  time.to-seconds(
    datetime(hour: 0, minute: 0, second: 2),
    datetime(hour: 0, minute: 0, second: 22),
    datetime(hour: 0, minute: 0, second: 42),
    datetime(hour: 0, minute: 1, second: 2),
    datetime(hour: 0, minute: 1, second: 22),
  ),
)
