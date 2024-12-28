#import "../assertations.typ"
#import "../color.typ": create-normalized-colors
#import "../plot-utils.typ": match, match-type, merge-strokes
#import "../math.typ": vec

#let draw-arrow(start: (), end: (), length: 3pt, width: 3pt, stroke: 1pt + black, arrow-color: black) = {
  place(line(start: start, end: end, stroke: stroke))
  let dir = (end.at(0) - start.at(0), end.at(1) - start.at(1))
  dir = dir.map(x => if type(x) == std.length {x.to-absolute().pt()} else {x/1%})
  // let angle = calc.atan2(dir.at(0), dir.at(1))
  
  let len = calc.sqrt(dir.map(x => x*x).sum())
  if len == 0 {return }
  dir = dir.map(x => x/len)
  let normal = (-dir.at(1), dir.at(0))

  let arrow-start = end
  let arrow-end = (end.at(0) + length*dir.at(0), end.at(1) + length*dir.at(1))
  let w = width/2
  let v1 = (arrow-start.at(0) - w*normal.at(0), arrow-start.at(1) - w*normal.at(1))
  let v2 = (arrow-start.at(0) + w*normal.at(0), arrow-start.at(1) + w*normal.at(1))
  if type(stroke) != std.stroke {
    stroke = std.stroke(stroke)
  }
  path(arrow-end, v1, v2, closed: true, fill: stroke.paint, stroke: none)
}



#let render-quiver(plot, transform) = {
  let scale = plot.scale

  let pivot = match(plot.style.pivot,
    "middle", () => dir => dir.map(x => -x*0.5),
    "tail", () => dir => (0, 0),
    "tip", () => dir => dir.map(x => -x),
    default: () => assert(false, message: "The argument `pivot` of `quiver` needs to be one of 'middle', 'tail', or 'tip'")
  )

  let get-arrow-color = match-type(
    plot.style.color,
    panic: true,
    color: () => i => merge-strokes(plot.style.color, plot.style.line),
    array: () => i => plot.style.color.at(i),
    auto-type: () => i => black,
  )

  
  for i in range(plot.x.len()) {
    for j in range(plot.y.len()) {
      let dir = plot.directions.at(i).at(j)
      // if pmath.is-nan(dir) { continue }
      let x = plot.x.at(i)
      let y = plot.y.at(j)
      let start = vec.add((x, y), pivot(dir.map(x => x/scale)))
      let p1 = transform(..start)
      let p2 = transform(..vec.add(start, dir.map(x => x/scale)))

      place(draw-arrow(start: p1, end: p2, stroke: get-arrow-color(j + i*plot.y.len())))
    }
  }
}


#let quiver(
  x, y, directions,
  color: black,
  map: color.map.viridis,
  vmin: auto,
  vmax: auto,
  norm: "linear",
  line: 1pt,
  pivot: "tip",  // or "tail" or "tip"
  scale: auto, 
  label: none,
  z-index: 2,
) = {
  
  if type(color) == array { 
    assert(type(color.first()) == array, message: "The argument `color` for `quiver` either needs to be a single value or a 2D array")
    let color-flat = color.flatten()
    assert(x.len() * y.len() == color-flat.len(), message: "The number of elements in `color` does not match the grid for `quiver()`")
    
    if type(color-flat.at(0, default: 0)) in (int, float) {
      let cinfo
      (color, cinfo) = create-normalized-colors(color-flat, map, norm, ignore-nan: false, vmin: vmin, vmax: vmax)
    }
  }
  
  (
    x: x,
    y: y,
    directions: directions,
    scale: scale,
    label: label,
    style: (
      line: line,
      scale: scale,
      pivot: pivot, 
      color: color
    ),
    plot: render-quiver,
    xlimits: () => (x.at(0), x.at(-1)),
    ylimits: () => (y.at(0), y.at(-1)),
    legend-handle: plot => {
      std.line(length: 100%, stroke: red)
    },
    z-index: z-index
  )
}
