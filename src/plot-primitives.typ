#import "assertations.typ"
#import "process-styles.typ": *

#let convert-point(x, y, transform) = {
  if type(x) in (int, float) {
    x = transform(x, 1).at(0)
  }
  if type(y) in (int, float) {
    y = transform(1, y).at(1)
  }
  return (x, y)
}
#let convert-bezier-curve(points, transform) = {
  let v = points.at(0)
  let p = convert-point(..v, transform)
  let result = (p,)
  
  for (x, y) in points.slice(1) {
    if type(x) in (int, float) {
      x = transform(x + v.at(0), 1).at(0) - p.at(0)
    }
    if type(y) in (int, float) {
      y = transform(1, y + v.at(1)).at(1) - p.at(1)
    }
    result.push((x, y))
  }
  return result
}

// point and size pt -> makes sense
// point and size data coords -> makes sense
// point data coords and size pt -> makes sense
// point data pt and size data coords -> makes no sense


#let convert-rect(x, y, width, height, transform) = {
  // at the end we only want lengths (or relative lengths)!
  let (x1, y1)  = convert-point(x, y, transform)
  if type(width) in (int, float) {
    assert(type(x) in (int, float), message: "Setting the width in terms of data coordinates makes no sense if the origin x coordinate is not in data coordinates")
    width = transform(x + width, 1).at(0) - transform(x, 1).at(0)
    // if width < 0pt {
    //   width *= -1
    //   x1 -= width
    // }
  }
  if type(height) in (int, float) {
    assert(type(y) in (int, float), message: "Setting the height in terms of data coordinates makes no sense if the origin y coordinate is not in data coordinates")
    height = transform(1, y + height).at(1) - transform(1, y).at(1) 
    // if height < 0pt {
    //   height *= -1
    //   y1 -= height
    // }
  }

  return (x1, width, y1, height)
}

// #rect(width: -2pt, "ad")

#let is-data-coordinates(coord) = type(coord) in (int, float)
#let all-data-coordinates(coords) = {
  return coords.map(is-data-coordinates).fold(true, (a, b) => a and b)
}


// ignores (relative) lengths and ratios and
// only accounts for data coordinates (which are
// given as floats).
#let compute-primitive-limits(coords) = {
  let filtered-coords = coords.filter(is-data-coordinates)
  if filtered-coords.len() == 0 { return none }
  return (calc.min(..filtered-coords), calc.max(..filtered-coords))
}

/// Plot a rectangle with origin $(x, y)$. The origin as well as width and height can either be given as `float` and are then interpreted as data coordinates or as `length`, `ratio`, or `relative` coordinates in the data frame. The point `(0pt,0pt)` is located at the top left corner of the frame. 
///
/// To access, e.g., the center, you can write `(50%, 50%)`. The dimensions may be one of the possible length types while the origin is given in data coordinates but not the other way round. 
///
/// - x (float, relative): Origin x coordinate. 
/// - y (float, relative): Origin y coordinate. 
/// - width (auto, float, relative): The rectangle's width, relative to the data frame. 
/// - height (auto, float, relative): The rectangle's height, relative to the data frame. 
/// - fill (none, color, gradient, pattern): The fill style for the rectangle.  
/// - stroke (stroke): The stroke style for the rectangle.
/// - radius (relative): The corner rounding radius for the rectangle.  
/// - inset (relative): See the built-in `rect()`.
/// - outset (relative): See the built-in `rect()`.
/// - label (content): The label for the plot.
/// - clip (boolean): See @plot:clip.
/// - z-index (float): See @plot:z-index.
#let rect(
  x, y,
  width: auto,
  height: auto, 
  fill: none,
  stroke: auto,
  radius: 0pt,
  inset: 5pt,
  outset: 0pt,
  label: none,
  clip: true,
  z-index: 2,
  ..body
) = {
  assertations.assert-no-named(body, fn: "rect")
  (
    x: x, 
    y: y,
    plot: (plot, transform) => { 
      let (x1, width, y1, height) = convert-rect(x, y, width, height, transform)
      place(dx: x1, dy: y1, std.rect(
        width: width, height: height, 
        fill: fill, stroke: stroke,
        radius: radius, inset: inset, outset: outset,
        body.pos().at(0, default: none)
      ))
    },
    xlimits: compute-primitive-limits.with((x, if all-data-coordinates((x, width)) { x + width } else { x })),
    ylimits: compute-primitive-limits.with((y, if all-data-coordinates((y, height)) { y + height } else { y })),
    legend-handle: plot => std.rect(width: 100%, height: 100%, fill: fill, stroke: stroke, radius: radius),
    label: label,
    clip: clip,
    z-index: z-index
  )
}


/// Plot an ellipse with origin $(x, y)$. See also @@rect()
///
/// - x (float, relative): Origin x coordinate. 
/// - y (float, relative): Origin y coordinate. 
/// - width (auto, float, relative): The rectangle's width, relative to the data frame. 
/// - height (auto, float, relative): The rectangle's height, relative to the data frame. 
/// - fill (none, color, gradient, pattern): The fill style for the rectangle.  
/// - stroke (stroke): The stroke style for the rectangle.
/// - inset (relative): See the built-in `rect()`.
/// - outset (relative): See the built-in `rect()`.
/// - label (content): The label for the plot.
#let ellipse(
  x, y,
  width: auto,
  height: auto, 
  fill: none,
  stroke: auto,
  inset: 5pt,
  outset: 0pt,
  label: none,
  clip: true,
  z-index: 2,
  ..body
) = {
  assertations.assert-no-named(body, fn: "ellipse")
  (
    x: x, 
    y: y,
    plot: (plot, transform) => { 
      let (x1, width, y1, height) = convert-rect(x, y, width, height, transform)
      place(dx: x1, dy: y1, std.ellipse(
        width: width, height: height, 
        fill: fill, stroke: stroke, 
        inset: inset, outset: outset,
        body.pos().at(0, default: none)
      ))
    },
    xlimits: compute-primitive-limits.with((x, if all-data-coordinates((x, width)) { x + width } else { x })),
    ylimits: compute-primitive-limits.with((y, if all-data-coordinates((y, height)) { y + height } else { y })),
    legend-handle: plot => std.ellipse(width: 100%, height: 100%, fill: fill, stroke: stroke),
    label: label,
    clip: clip,
    z-index: z-index
  )
}

// Convert a vertex for `path`. A vertex may either be a single vertex
// or a pair/triple of vertices describing a point with handles on a
// bezier curve. 
#let convert-vertex(v, transform: it => it) = {
  if type(v.at(0)) == array {
    return v.map(p => convert-point(..p, transform))
  } else {
    convert-point(..v, transform)
  }
}

// #let 


/// Plot a path. Each vertex may be given as data coordinates or document coordinates (see also @@rect()).
///
/// - fill (none, color, gradient, pattern): The fill style for the rectangle.  
/// - stroke (stroke): The stroke style for the rectangle.
/// - radius (relative): The corner rounding radius for the rectangle.  
/// - label (content): The label for the plot.
#let path(
  fill: none,
  stroke: auto,
  closed: false,
  label: none,
  clip: true,
  z-index: 2,
  ..vertices
) = {
  let sub(p, q) = (p.at(0) - q.at(0), p.at(1) - q.at(1))
  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
  assertations.assert-no-named(vertices, fn: "path")
  vertices = vertices.pos()
  let all-points = vertices.enumerate().map(((i, v)) => {
    if type(v.at(0)) != array { return (v,) }
    if v.len() == 3 { 
      return (v.at(0),) + v.slice(1).map(c => {
         if not c.map(type).all(x => x in (int, float)) { return v.at(0) }
        add(v.at(0), c)
      }) 
    } 
    let vs = (v.at(0),)
    if i != 0 and v.at(1).map(type).all(x => x in (int, float)){
      vs.push(add(v.at(0), v.at(1)))
    }
    if i != vertices.len() - 1 {
      // vs.push(sub(v.at(0), v.at(1)))
    }
    return vs
  }).join()
  // vertices = all-points  
  // let all-points = vertices
  (
    vertices: vertices,
    plot: (plot, transform) => { 
      let new-vertices = vertices.map(v => {
        if type(v.at(0)) != array { return convert-point(..v, transform) }
        return convert-bezier-curve(v, transform)
        let p = convert-point(..v.at(0), transform)
        let cs = v.slice(1).map(c => {
          let cabs = add(v.at(0), c)
          let cabs = c
          sub(convert-point(..cabs, transform), p)
        })
        (p,) + cs
      })
      place(std.path(
        fill: fill, stroke: stroke, closed: closed,
        // ..vertices.map(((x, y)) => convert-point(x, y, transform))
        ..new-vertices
      ))
    },
    xlimits: compute-primitive-limits.with(all-points.map(x => x.at(0))),
    ylimits: compute-primitive-limits.with(all-points.map(x => x.at(1))),
    legend-handle: plot => std.rect(width: 100%, height: 100%, fill: fill, stroke: stroke),
    label: label,
    clip: clip,
    z-index: z-index
  )
}




/// Plot a path. Each vertex may be given as data coordinates or document coordinates (see also @@rect()).
///
/// - fill (none, color, gradient, pattern): The fill style for the rectangle.  
/// - stroke (stroke): The stroke style for the rectangle.
/// - radius (relative): The corner rounding radius for the rectangle.  
/// - label (content): The label for the plot.
#let line(
  start, 
  end,
  stroke: auto,
  label: none,
  clip: true,
  z-index: 2,
) = {
  let vertices = (start, end)
  (
    plot: (plot, transform) => { 
      place(std.path(
        stroke: stroke,
        ..vertices.map(convert-vertex.with(transform: transform))
      ))
    },
    xlimits: compute-primitive-limits.with(vertices.map(x => x.at(0))),
    ylimits: compute-primitive-limits.with(vertices.map(x => x.at(1))),
    legend-handle: plot => std.line(start: (0pt, 100%), end: (100%, 0pt), stroke: stroke),
    label: label,
    clip: clip,
    z-index: z-index
  )
}

#let place(
  content,
  x: 0pt, 
  y: 0pt,
  align: center + horizon,
  clip: false,
  z-index: 3,
) = {
  (
    plot: (plot, transform) => { 
      let (px, py) = convert-point(x, y, transform)
      std.place(std.place(twod-ify-alignment(align), content), dx: px, dy: py)
    },
    xlimits: () => none,
    ylimits: () => none,
    label: none,
    legend-handle: (..) => none,
    clip: clip,
    z-index: z-index
  )
}

