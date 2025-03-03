#import "../assertations.typ"
#import "../algorithm/contour.typ": *
#import "../color.typ": create-normalized-colors
#import "../math.typ": minmax, mesh

#let render-contour(plot, transform) = {
  if "make-legend" in plot {
    return std.line(length: 100%, stroke: plot.line-colors.first())
  }

  let get-widths(x) = {
    x.zip(x.slice(1)).map(((x, x1)) => x1 - x)
  }
  let get-size(i, x) = {
    if i < x.len() - 1 { 
      let d2 = x.at(i + 1) - x.at(i)
      if i > 0 {
        (x.at(i) - x.at(i - 1), d2)
      } else {
        (d2, d2)
      }
    }
    else { 
      let d = x.at(-1) - x.at(-2)
      (d, d)
    }
  }
  let widths = get-widths(plot.x)
  let heights = get-widths(plot.x)
  for i in range(plot.x.len()) {
    for j in range(plot.y.len()) {
      let x = plot.x.at(i)
      let y = plot.y.at(j)
      
      let (w1, w2) = get-size(i, plot.x)
      let (h1, h2) = get-size(j, plot.y)
      let (x1, y1) = transform(x - w1/2, y + h2/2)
      let (x2, y2) = transform(x + w2/2, y - h1/2)
      let (x2, y2) = transform(x, y)
      // let fill = plot.color.at(j + i*plot.y.len())
      let fill = red
      // place(dx: x1, dy: y1, rect(stroke: none, width: x2 - x1, height: y2 - y1, fill: fill))
      // let (x2, y2) = transform(x, y)
      // place(place(center+horizon, circle(radius: 1pt,[#text(white,str(calc.round(plot.z.at(i).at(j))))])), dx: x2, dy: y2)
    }
  }
  let (contours, contours1, filled-contours) = plot.contours


  let preview-steps(contour) = place(scale(origin: top + left, 25%,
    table(columns: (5cm,) * 4, rows: 4cm,
      ..contour.map(x => path(
        fill: white, 
        stroke: none,
        ..x.at(0).map(p => transform(..p)),
      ) + place(center + horizon, text(3em,if x.at(2) == left [−]else[+])))
    )
  ))
    
  if plot.fill { 
  
    let (xmin, xmax) = minmax(plot.x)
    let (ymin, ymax) = minmax(plot.y)
    let canvas-rect = ((xmax, ymax), (xmax, ymin), (xmin, ymin), (xmin, ymax), (xmax, ymax)) // right-turning curve
    // assert.eq(compute-polygon-orientation(..canvas-rect), right)
  
    for (i, contour) in filled-contours.enumerate() {
      // set path(stroke: none, fill: plot.line-colors.at(i), closed: true)
      set curve(stroke: none, fill: plot.line-colors.at(i))

      let points
      if i == 0 {
        points = canvas-rect
      } else {
        if contour.len() == 0 { continue }
        if contour.at(0).at(2) == left {
          contour = ((canvas-rect, 0, false),) + contour
        }
        points = contour.map(p => p.at(0)).join(((0,0),))
        points.push((0,0))
      }

      // place(path(
      //   ..points.map(p => transform(..p)),
      // ))
      points = points.map(p => transform(..p))
      place(curve(
        curve.move(points.first()),
        ..points.slice(1).map(curve.line),
        curve.close()
      ))

    }
  } else {
      
    for (i, contour) in contours.enumerate() {
      set line(stroke: plot.line-colors.at(i))
      // set path(stroke: plot.line-colors.at(i))
      // set path(stroke: plot.stroke)
      set curve(stroke: plot.line-colors.at(i))
      set curve(stroke: plot.stroke)
      for path in contour {
        path = path.map(p => transform(..p))
        place(std.curve(
          curve.move(path.first()),
          ..path.slice(1).map(curve.line)
        ))
      }
    }
    
    // for (i, contour) in contours.enumerate() {
    //   set line(stroke: plot.line-colors.at(i))
    //   set path(stroke: plot.line-colors.at(i))
    //   for path in contour {
    //     let prev = path.first()
    //     for p in path.slice(1) {
    //       place(draw-arrow(start: transform(..p), end: transform(..prev)))
    //       prev = p
    //     }
    //     // place(std.path(..path.map(p => transform(..p))))
    //   }
    // }
    
    // let clrs = (red, blue, purple, green, orange, gray, black)
    // let k = 0
    // for (i, contour) in contours.enumerate() {
    //   set line(stroke: plot.line-colors.at(i))
    //   for cycle in contour {
    //     k +=1
    //     place(dx: i*2pt,path(..cycle.map(p => transform(..p)), stroke: .8pt + clrs.at(calc.rem(k, clrs.len()))))
    //   }
    // }
  }


  if filled-contours.len() > 10 {
    // preview-steps(filled-contours.at(5))
  }
}


/// Creates a contour plot for a 3-dimensional mesh. Given a set of `levels`, 
/// a number of cuts through the mesh are computed automatically and displayed
/// as contour lines. Contour plots can be either just stroked
/// 
/// ```example
/// #lq.diagram(
///   width: 4cm, height: 4cm,
///   lq.contour(
///     lq.linspace(-5, 5, num: 12),
///     lq.linspace(-5, 5, num: 12),
///     (x, y) => x * y, 
///     map: color.map.icefire,
///   )
/// )
/// ```
/// or filled per-level. 
/// ```example
/// #lq.diagram(
///   width: 4cm, height: 4cm,
///   lq.contour(
///     lq.linspace(-5, 5, num: 12),
///     lq.linspace(-5, 5, num: 12),
///     (x, y) => x * y, 
///     map: color.map.icefire,
///     fill: true
///   )
/// )
/// ```
#let contour(

  /// A one-dimensional array of $x$ data coordinates. 
  /// -> array
  x, 
  
  /// A one-dimensional array of $y$ data coordinates. 
  /// -> array
  y, 


  /// Specifies the $z$ coordinates (height) for all combinations of $x$ and $y$ 
  /// coordinates. This can either be a two-dimensional array of dimensions $m×n$ 
  /// where $m$ is the length of @contour.x and $n$ is the length of @contour.y, 
  /// or a function that takes an `x` and a `y` value and returns a corresponding 
  /// `z` coordinate. Also see the function @mesh for creating meshes. 
  /// -> array | function
  z,

  /// Specifies the levels to compute contours for. If this is an integer, an 
  /// according number of levels is automatically selected evenly from a ticking 
  /// pattern. TODO: unclear. 
  /// The desired levels can also be selected manually by passing an array of ($z$) 
  /// coordinates. 
  /// -> int | array
  levels: 10,

  /// Whether to fill the contour levels. 
  /// -> bool
  fill: false,

  /// How to stroke the contours in the cases that `fill: false`. If this
  /// argument specifies a color, the coloring from the @contour.map is
  /// overriden. 
  /// -> stroke
  stroke: 0.7pt,
  
  /// A color map in form of a gradient or an array of colors to sample from. 
  /// -> array | gradient
  map: color.map.viridis,

  /// Sets the data value that corresponds to the first color of the color map. If set 
  /// to `auto`, it defaults to the minimum $z$ value.
  /// -> auto | int | float
  min: auto,

  /// Sets the data value that corresponds to the last color of the color map. If set 
  /// to `auto`, it defaults to the maximum $z$ value.
  /// -> auto | int | float
  max: auto,

  /// The normalization method used to scale $z$ coordinates to the range 
  /// $[0,1]$ before mapping them to colors using the color map. This can be a 
  /// @scale, a string that is the identifier of a built-in scale or a function 
  /// that takes one argument. See @colormesh.norm. 
  /// -> lq.scale | str | function
  norm: "linear",
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram
  /// objects. See @plot.z-index.  
  /// -> int | float
  z-index: 2

) = {
  if type(z) == function {
    z = mesh(x, y, z)
  }
  let z-flat = z.flatten()
  assert.eq(x.len() * y.len(), z-flat.len())
  
  let (z0, z1) = (calc.min(..z-flat), calc.max(..z-flat))
  if z0 == z1 { z0 -= 1; z1 += 1}
  if type(levels) == int {
    import "../algorithm/ticking.typ"
    let range = ticking.locate-ticks-linear(z0, z1, num-ticks-suggestion: levels)
    levels = range.ticks
  }
  
  if min == auto { min = calc.min(..z-flat) }
  if max == auto { max = calc.max(..z-flat) }
  let (color, cinfo) = create-normalized-colors(levels, map, norm, min: min, max: max)


  let stroke-contours = generate-contours(x, y, z, levels, z-range: z1 - z0)

  
  let boundaries = (xmin: x.first(), xmax: x.last(), ymin: y.first(), ymax: y.last())
  let closed-contours = stroke-contours.map(paths => {
    paths.map(close-path-at-boundaries.with(boundaries: boundaries)).filter(x => x != none)
  })


  let sort-cycles(cycles) = {
    let marked-cycles = cycles.map(cycle => (
      cycle, 
      calc.min(..cycle.map(p => p.at(0))),
      compute-polygon-orientation(..cycle)
    ))
    return marked-cycles.sorted(key: x => x.at(1))
  }

  let fill-contours = closed-contours.map(cycles => sort-cycles(cycles))

  let contours = (stroke-contours, closed-contours, fill-contours)
  
  (
    cinfo: cinfo,
    x: x,
    y: y,
    z: z,
    levels: levels,
    line-colors: color,
    contours: contours,
    fill: fill,
    stroke: stroke,
    label: label,
    plot: render-contour,
    xlimits: () => (x.at(0)*1fr, x.at(-1)*1fr),
    ylimits: () => (y.at(0)*1fr, y.at(-1)*1fr),
    legend: true,
    z-index: z-index
  )
}
