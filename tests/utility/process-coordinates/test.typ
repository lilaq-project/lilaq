#import "/src/logic/process-coordinates.typ": *


#assert.eq(stepify((), step: start), ())
#assert.eq(stepify(((0,0),), step: start), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: start), ((0,0), (0,.7), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: start), ((0,0), (0,.7), (1,.7), (1,-.1), (3,-.1)))

#assert.eq(stepify((), step: end), ())
#assert.eq(stepify(((0,0),), step: end), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: end), ((0,0), (1,0), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: end), ((0,0), (1,0), (1,.7), (3, .7), (3,-.1)))

#assert.eq(stepify((), step: center), ())
#assert.eq(stepify(((0,0),), step: center), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: center), ((0,0), (0.5,0), (0.5, .7), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: center), ((0,0), (.5,0), (.5, .7), (1,.7), (2, .7), (2, -.1), (3,-.1)))
