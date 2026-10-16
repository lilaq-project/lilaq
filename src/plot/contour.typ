#import "../assertations.typ"
#import "../algorithm/contour.typ": close-path-at-boundaries, compute-polygon-orientation
#import "../logic/sample-colors.typ": sample-colors
#import "../math.typ": minmax, mesh

#import "@preview/elembic:1.1.1" as e



#let contour-level-label = e.element.declare(
  "contour-level-label",
  prefix: "lilaq",
  display: it => pad(it.body),
  fields: (
    e.field("body", e.types.option(content), required: true),
  ),
)


#let render-contour(plot, transform) = {
  if "make-legend" in plot {
    return std.line(length: 100%, stroke: plot.level-colors.first())
  }

  let tags = auto
  if tags == auto {
    tags = plot.levels
    import "../logic/tick-format.typ"
    tags = tick-format.linear(tags).labels
  }
  tags = tags.map(tag => {
    set pad(x: .3em)
    set text(.8em)
    contour-level-label(tag)
  })
  
  import "@local/komet:0.2.0"
  let x = plot.x
  let y = plot.y
  
  if not plot.is-filled {
    x = x.map(x => transform(x, 1).at(0).pt())
    y = y.map(y => transform(1, y).at(1).pt())
  }  

  let label-lengths = if plot.is-filled or plot.level-labels == none { none } else {
    tags.map(label => measure(label).width)
  }
  let (contours, labels: label-positions) = komet.contour(
    x, y, 
    plot.z, 
    plot.levels, 
    label-lengths: label-lengths,
    // label-every-line: true
  )



  if plot.is-filled {
    let boundaries = (xmin: x.first(), xmax: x.last(), ymin: y.first(), ymax: y.last())

    contours = contours.map(paths => {
      paths.map(close-path-at-boundaries.with(boundaries: boundaries)).filter(x => x != none)
    })
  
    let (xmin, xmax) = minmax(plot.x)
    let (ymin, ymax) = minmax(plot.y)
    let canvas-rect = ((xmax, ymax), (xmax, ymin), (xmin, ymin), (xmin, ymax), (xmax, ymax)) // right-turning curve
    // assert.eq(compute-polygon-orientation(..canvas-rect), right)
    
    for (i, contour) in contours.enumerate() {

      let to-closed-curve(contour) = {
        if contour.len() == 0 { return () }
        contour = contour.map(p => transform(..p))
        return (
          curve.move(contour.first()),
          ..contour.slice(1).map(curve.line),
          curve.close(),
        )
      }
      if i == 0 {
        contour = (canvas-rect,)
      }
      if contour.len() == 0 { continue }
      if compute-polygon-orientation(..contour.first()) == left {
        contour = (canvas-rect,) + contour
      }
      let contour-curve = curve(..contour.map(to-closed-curve).join())
      
      
      set curve(stroke: none, fill: plot.level-colors.at(i))
      place(contour-curve)

      if plot.fill.at(i) != auto {
        set curve(fill: plot.fill.at(i))
        place(contour-curve)
      }
    }

  } else {
    for (contour, color, positions, label, stroke) in contours.zip(plot.level-colors, label-positions, tags, plot.stroke) {
      set curve(stroke: color)
      set curve(stroke: stroke)
      for path in contour {
        path = path.map(p => p.map(q => q * 1pt))
        place(std.curve(
          curve.move(path.first()),
          ..path.slice(1).map(curve.line)
        ))
      }
      
      for position in positions {
        set text(color)
        let (x, y) = (1pt * position.x, 1pt * position.y)
        place(dx: x, dy: y, 
          place(center + horizon, 
            rotate(position.angle, reflow: true, 
              text(1em, label)
            )
          )
        )
      }

    }
    
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
  /// coordinates. This can either be a 
  /// - two-dimensional $m×n$-array where $m$ is the length of @contour.y 
  ///   and $n$ is the length of @contour.x (for each $y$ value, a row of $x$
  ///   values), 
  /// - or a function that takes an `x` and a `y` value and returns a 
  ///   corresponding `z` coordinate. 
  /// Also see the function @mesh that can be used to create such meshes. 
  /// -> array | function
  z,

  /// Specifies the levels to compute contours for. If this is an integer, an 
  /// according number of levels is automatically selected evenly from a ticking 
  /// pattern. TODO: unclear. 
  /// The desired levels can also be selected manually by passing an array of ($z$) 
  /// coordinates. 
  /// -> int | array
  levels: 10,

  /// Controls the insertion of level labels into the contour lines.
  /// This only applies when @contour.fill is `false`, otherwise, no labels are
  /// drawn. When set to `auto`, labels are added to all contour lines that provide a sufficient amount of space.
  /// -> none | auto
  level-labels: none,

  /// Whether to fill the contour levels. 
  /// This can also be an array of fills for each level (if the
  /// number of fills is less than the number of levels, they are repeated). 
  /// -> none | auto | array
  fill: none,

  /// How to stroke the contours in the cases that `fill: false`. If the
  /// stroke specifies a color, the coloring from the @contour.map is
  /// overridden. This can also be an array of strokes for each level (if the
  /// number of strokes is less than the number of levels, they are repeated). 
  /// -> stroke | array
  stroke: 0.7pt,
  
  /// A color map in form of a gradient or an array of colors to sample from
  /// according to @contour.norm. 
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
  assert.eq(
    y.len(), z.len(), 
    message: "`colormesh`: The number of `y` coordinates and the number of rows in `z` must match. Found " + str(y.len()) + " != " + str(z.len())
  )
  assert(
    type(z) == array and type(z.first()) == array, 
    message: "`colormesh`: `z` expects a 2D array"
  )
  assert.eq(
    x.len(), z.first().len(), 
    message: "`colormesh`: The number of `x` coordinates and the row length in `z` must match. Found " + str(x.len()) + " != " + str(z.first().len())
  )
  
  let z-flat = z.flatten()
  let z0 = if min != auto { min } else { calc.min(..z-flat) }
  let z1 = if max != auto { max } else { calc.max(..z-flat) }
  if z0 == z1 { z0 -= 1; z1 += 1 }


  if type(levels) == int {
    import "../logic/tick-locate.typ"
    let range = tick-locate.linear(z0, z1, num-ticks-suggestion: levels)
    levels = range.ticks
  }

  assert(
    levels.sorted() == levels,
    message: "contour.levels need to be sorted, got " + repr(levels)
  )
  
  if min == auto { min = calc.min(..z-flat) }
  if max == auto { max = calc.max(..z-flat) }
  // if min == auto { min = calc.min(..levels) }
  // if max == auto { max = calc.max(..levels) }
  let (level-colors, cinfo) = sample-colors(levels, map, norm, min: min, max: max)

  // backwards compatibility
  if fill == true { fill = auto }
  if fill == false { fill = none }

  let is-filled = fill != none
  if type(fill) != array {
    fill = (fill,) * levels.len()
  } else {
    fill = (fill * calc.ceil(levels.len() / fill.len())).slice(0, levels.len())
  }
  
  if type(stroke) != array {
    stroke = (stroke,) * levels.len()
  } else {
    stroke = (stroke * calc.ceil(levels.len() / stroke.len()))
  }
  
  (
    cinfo: cinfo,
    x: x,
    y: y,
    z: z,
    levels: levels,
    level-colors: level-colors,
    level-labels: level-labels,
    fill: fill,
    is-filled: is-filled,
    stroke: stroke,
    label: label,
    plot: render-contour,
    xlimits: () => (x.at(0)*1fr, x.at(-1)*1fr),
    ylimits: () => (y.at(0)*1fr, y.at(-1)*1fr),
    legend: true,
    z-index: z-index
  )
}
