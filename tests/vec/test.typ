#import "/src/lilaq.typ" as lq


#assert.ne(
  lq.vec.jitter((0, 1, 2)), 
  (0, 1, 2)
)

// Auto-seed, test for permutations
#assert.ne(
  lq.vec.jitter((0,1,2,4,3,5,6), seed: auto),
  lq.vec.jitter((0,1,2,3,4,5,6), seed: auto)
)
