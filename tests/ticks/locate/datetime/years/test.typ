#import "/src/lilaq.typ" as lq
#import "/src/logic/time.typ"


#assert.eq(
  lq.tick-locate.years(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2010, month: 11, day: 3),
    ),
    num-ticks-suggestion: 5,
  ).ticks,
  time.to-seconds(
    datetime(year: 2002, month: 1, day: 1),
    datetime(year: 2004, month: 1, day: 1),
    datetime(year: 2006, month: 1, day: 1),
    datetime(year: 2008, month: 1, day: 1),
    datetime(year: 2010, month: 1, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.years(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2010, month: 11, day: 3),
    ),
    num-ticks-suggestion: 10,
  ).ticks,
  time.to-seconds(
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2002, month: 1, day: 1),
    datetime(year: 2003, month: 1, day: 1),
    datetime(year: 2004, month: 1, day: 1),
    datetime(year: 2005, month: 1, day: 1),
    datetime(year: 2006, month: 1, day: 1),
    datetime(year: 2007, month: 1, day: 1),
    datetime(year: 2008, month: 1, day: 1),
    datetime(year: 2009, month: 1, day: 1),
    datetime(year: 2010, month: 1, day: 1),
  ),
)

#assert.eq(
  lq.tick-locate.years(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2010, month: 11, day: 3),
    ),
    density: 200%,
  ).ticks,
  time.to-seconds(
    datetime(year: 2001, month: 1, day: 1),
    datetime(year: 2002, month: 1, day: 1),
    datetime(year: 2003, month: 1, day: 1),
    datetime(year: 2004, month: 1, day: 1),
    datetime(year: 2005, month: 1, day: 1),
    datetime(year: 2006, month: 1, day: 1),
    datetime(year: 2007, month: 1, day: 1),
    datetime(year: 2008, month: 1, day: 1),
    datetime(year: 2009, month: 1, day: 1),
    datetime(year: 2010, month: 1, day: 1),
  ),
)


#assert.eq(
  lq.tick-locate.years(
    ..time.to-seconds(
      datetime(year: 2000, month: 7, day: 3),
      datetime(year: 2010, month: 11, day: 3),
    ),
    tick-distance: 4
  ).ticks,
  time.to-seconds(
    datetime(year: 2004, month: 1, day: 1),
    datetime(year: 2008, month: 1, day: 1),
  ),
)


#assert.eq(
  lq.tick-locate.years(
    ..time.to-seconds(
      datetime(year: 0, month: 7, day: 3),
      datetime(year: 2010, month: 11, day: 3),
    )
  ).ticks,
  time.to-seconds(
    datetime(year: 500, month: 1, day: 1),
    datetime(year: 1000, month: 1, day: 1),
    datetime(year: 1500, month: 1, day: 1),
    datetime(year: 2000, month: 1, day: 1),
  ),
)
