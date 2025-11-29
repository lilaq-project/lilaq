
#import "/src/lilaq.typ" as lq

// Utilities to 
// - make it easier to single out test features (e.g., by removing tick lines
//   when they are not explicitly tested) to avoid references images needing 
//   to be updated when defaults are changed. 
// - reduce reference image size (e.g., by graying out text)

// Display gray boxes instead of text in labels and titles. 
#let obfuscate(body) = {
  let mask = it => box(fill: gray, hide(it))
  show lq.selector(lq.label): mask
  show lq.selector(lq.title): mask
  show lq.selector(lq.tick-label): mask
  body
}

// No tick lines, no grid
#let no-ticks(body) = {
  show: lq.set-tick(inset: 0pt, outset: 0pt)
  show: lq.set-diagram(grid: none)
  body
}

#let canonical-diagram(body) = {
  show: lq.set-diagram(margin: 6%)
  body
}

#let canonical-legend(body) = {
  show: lq.set-legend(
    stroke: 1pt + black,
    radius: 0pt,
  )
  body
}

#let minimal(body) = {
  show: canonical-diagram
  show: canonical-legend
  show: no-ticks
  body
}