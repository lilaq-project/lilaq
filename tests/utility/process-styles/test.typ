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




// Black text on white paper: the previous defaults.
#context assert.eq(paper(), white)
#context assert.eq(ink(), black)
#context assert.eq(ink(mix: 20%).to-hex(), luma(80%).to-hex())
#context assert.eq(ink(mix: 100% / 3).to-hex(), gray.to-hex())

// Text filled with a gradient counts as black.
#set text(fill: gradient.linear(red, blue))
#context assert.eq(ink(), black)

// Light text on a dark page.
#set page(fill: rgb("#18191c"))
#set text(fill: rgb("#e8eaed"))
#context assert.eq(paper(), rgb("#18191c"))
#context assert.eq(ink(), rgb("#e8eaed"))
#context assert.eq(ink(mix: 20%).to-hex(), "#424346")
#context assert.eq(ink(mix: 100% / 3).to-hex(), "#5d5f62")
