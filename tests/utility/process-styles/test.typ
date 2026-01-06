#import "/src/process-styles.typ": *



#assert.eq(twod-ify-alignment(top + right), top + right)
#assert.eq(twod-ify-alignment(top + left), top + left)
#assert.eq(twod-ify-alignment(top), top + center)
#assert.eq(twod-ify-alignment(bottom), bottom + center)
#assert.eq(twod-ify-alignment(horizon), horizon + center)
#assert.eq(twod-ify-alignment(left), left + horizon)
#assert.eq(twod-ify-alignment(right), right + horizon)
#assert.eq(twod-ify-alignment(center), center + horizon)
#assert.eq(twod-ify-alignment(center + bottom), center + bottom)
#assert.eq(twod-ify-alignment(right, vertical: bottom), right + bottom)
#assert.eq(twod-ify-alignment(top, horizontal: right), top + right)



#assert.eq(merge-fills(red, blue), red)
#assert.eq(merge-fills(red, blue, green), red)
#assert.eq(merge-fills(auto, blue, green), blue)
#assert.eq(merge-fills(auto, auto, auto, black, red), black)
#assert.eq(merge-fills(auto), auto)
#assert.eq(merge-fills(none), none)


#assert.eq(merge-strokes(auto), stroke())
#assert.eq(merge-strokes(none), none)
#assert.eq(merge-strokes(1pt), stroke(1pt))
#assert.eq(merge-strokes(1pt, black), 1pt + black)
#assert.eq(merge-strokes(auto, red), stroke(red))
#assert.eq(merge-strokes(red, auto), stroke(red))
#assert.eq(merge-strokes(red, stroke(dash: "dotted"), 4pt, 10pt), stroke(paint: red, dash: "dotted", thickness: 4pt))
#assert.eq(merge-strokes(stroke(), 1pt, tiling("1"), red, auto, stroke()), 1pt + tiling("1"))
#assert.eq(merge-strokes(none, stroke(), 1pt, tiling("1"), red, auto, stroke()), none)
#assert.eq(merge-strokes(1pt, none, tiling("1"), red, auto, stroke()), stroke(1pt))

