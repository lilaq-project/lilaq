#import "/src/algorithm/ticking.typ": *


#assert.eq(
  locate-ticks-step(1, 12).ticks,
  (2, 4, 6, 8, 10, 12),
)
#assert.eq(
  locate-ticks-step(1, 12, num-ticks: 2).ticks,
  (5, 10),
)
#assert.eq(
  locate-ticks-step(105, 121, num-ticks: 3).ticks,
  (105, 110, 115, 120),
)
#assert.eq(
  locate-ticks-step(1, 12, steps: (1, 3, 6, 12)).ticks,
  (3, 6, 9, 12),
)
#assert.eq(
  locate-ticks-step(1, 23, steps: (1, 3, 6, 12), num-ticks: 4.9).ticks,
  (6, 12, 18),
)
