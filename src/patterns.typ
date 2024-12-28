#import "process-styles.typ": merge-strokes



#let crosses(
  size: 30pt, stroke: 1pt
) = pattern(size: (size, size))[
  #place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
  #place(line(start: (0%, 100%), end: (100%, 0%), stroke: stroke))
]

#let diag(
  stroke: 3pt,
  angle: 45deg,
  gap: 1cm
) = {
  let m = calc.tan(angle)
  let width = 90pt
  let height = m * width
  
  
  pattern(size: (width, height), {
    stroke = merge-strokes(stroke, std.stroke(cap: "square"))

    place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
    place(line(start: (90%, -10%), end: (110%, 10%), stroke: stroke))
    place(line(start: (-10%, 90%), end: (10%, 110%), stroke: stroke))
    // place(line(start: (0%, 50%), angle: angle, length: width, stroke: stroke))
    // place(line(start: (50%, 0%), angle: angle, length: width, stroke: stroke))
    // place(rect(stroke: .2pt + blue, width: 100%, height: 100%))
    // place(line(start: (0%, 50%), end: (50%, 100%), stroke: stroke))
    // place(line(start: (50%, 0%), end: (100%, 50%), stroke: stroke))
    // #place(line(start: (0%, 100%), end: (100%, 0%)))
  })

}
