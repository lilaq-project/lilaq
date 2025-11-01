#import "/src/lilaq.typ" as lq

#assert.eq(
  lq.vec.transform((1, 5, 4), (-2, 50, .25), (a, b) => (a / b)),
  (-0.5, 0.1, 16),
)

#assert.eq(
  lq.vec.add((1, 5, 4), (-2, 2.2, 99)),
  (-1, 7.2, 103),
)

#assert.eq(
  lq.vec.subtract((1, 5, 4), (-2, 2.2, 99)),
  (3, 2.8, -95),
)

#assert.eq(
  lq.vec.inner((1, 5, 4), (-2, 2.2, 99)),
  -2 + 5 * 2.2 + 4 * 99,
)

#assert.eq(
  lq.vec.multiply((1, 5, 4), -2),
  (-2, -10, -8),
)


#assert.ne(
  lq.vec.jitter((0, 1, 2)),
  (0, 1, 2),
)

// Auto-seed, test for permutations
#assert.ne(
  lq.vec.jitter((0, 1, 2, 4, 3, 5, 6), seed: auto),
  lq.vec.jitter((0, 1, 2, 3, 4, 5, 6), seed: auto),
)
