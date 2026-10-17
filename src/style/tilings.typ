#import "../process-styles.typ": merge-strokes



#let crosses(
  size: 30pt, stroke: 1pt
) = tiling(size: (size, size))[
  #place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
  #place(line(start: (0%, 100%), end: (100%, 0%), stroke: stroke))
]

#let diag(
  stroke: .7pt + luma(10%),
  fill: none,
  angle: 45deg,
  gap: 7pt
) = {
  stroke = merge-strokes(stroke, std.stroke(cap: "square"))
  let rect = rect.with(fill: fill, inset: 0pt, width: 100%, height: 100%, stroke: none)
  if angle in (90deg, 270deg) {
    return tiling(
      size: (gap, gap), 
      rect(line(start: (50%, 0%), end: (50%, 100%), stroke: stroke))
    )
  }
  if angle in (0deg, 180deg) {
    return tiling(
      size: (gap, gap), 
      rect(line(start: (0%, 50%), end: (100%, 50%), stroke: stroke))
    )
  }
  let m = calc.tan(angle)
  let width = calc.abs(gap / calc.sin(angle))
  let height = calc.abs(m * width)
  let flip-x = 100% * float.signum(calc.sin(angle))
  let flip-y = flip-x * float.signum(m)
  
  
  tiling(size: (width, height), scale(x: flip-x, y: flip-y, rect({

    place(line(start: (0%, 0%), end: (100%, 100%), stroke: stroke))
    place(line(start: (0%, -100%), end: (200%, 100%), stroke: stroke))
    place(line(start: (-100%, 0%), end: (100%, 200%), stroke: stroke))
  })))

}
#scale(200%, block(
  width: 4cm, height: 4cm,
  fill: diag()
))
