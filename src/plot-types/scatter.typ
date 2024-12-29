#import "../plot-utils.typ": match-type, merge-strokes
#import "../assertations.typ"
#import "../process-points.typ": filter-nan-points
#import "../color.typ": create-normalized-colors
#import "../math.typ": minmax
#import "../cycle.typ": mark, prepare-mark, _auto
#import "../utility.typ": if-auto

// #let plot-legend-handle-scatter(plot) = {
//   plot.style.mark-size = 2pt
//   let mark-color = match-type(
//     plot.color, 
//     color: plot.color,
//     array: () => plot.style.map.sample(0%),
//     auto-type: () => black
//   )
//   let alpha = match-type(
//     plot.alpha,
//     ratio: () => plot.alpha,
//     array: () => plot.alpha.at(0, default: 100%)
//   )

//   if plot.style.marker-stroke.paint == auto {
//     plot.style.marker-stroke = merge-strokes(plot.style.marker-stroke, mark-color)
//   }
//   plot.style.mark-color = mark-color.lighten(100% - alpha)
//   place(horizon + center, (plot.style.mark)(plot.style))
// }


#let render-scatter(plot, transform) = {
  
  let get-marker-size = match-type(
    plot.size,
    length: () => i => plot.size,
    array: () => i => plot.size.at(i),
    auto-type: () => i => auto,
    panic: true
  )
  
  let get-marker-color = match-type(
    plot.color,
    color: () => i => plot.color,
    array: () => i => plot.color.at(i),
    auto-type: () => i => _auto,
    panic: true,
  )
  let get-alpha = match-type(
    plot.alpha,
    ratio: () => i => plot.alpha,
    array: () => i => plot.alpha.at(i),
    panic: true,
  )
  
  let points = filter-nan-points(plot.x.zip(plot.y))
  if "make-legend" in plot {
    points = ((0.5,.5),)
  }

  
  
  show: prepare-mark.with(
    func: plot.style.mark, 
  )
  set mark(stroke: plot.style.stroke)

  for (i, p) in points.enumerate() {
    let p = transform(..p)
    
    let size = get-marker-size(i)
    let mark-color = get-marker-color(i)
    
    let options = (
      fill: mark-color.transparentize(100% - get-alpha(i))
    )
    if size != auto { options.inset = size }
    if plot.style.stroke != none { options.stroke = merge-strokes(plot.style.stroke, mark-color) }
    
    place(dx: p.at(0), dy: p.at(1), mark(..options))
  }
}




/// Produces a scatter plot from the given coordinates. The mark size and 
/// color can be set per point (this discerns @scatter from @plot). 
///
/// ```example
/// #let x = lq.linspace(0, 10)
/// 
/// #lq.diagram(
///   lq.scatter(x, x.map(x => calc.sin(x)))
/// )
/// ```
#let scatter(
  
  /// An array of $x$ coordinates. 
  /// -> array
  x, 
  
  /// An array of $y$ coordinates. The number of $x$ and $y$ coordinates must match. 
  /// -> array
  y, 
  
  /// Marker sizes as `float` values. The area of the markers will scale proportionally 
  /// with these numbers while the actual mark size (width) will scale with 
  /// $sqrt("size")$.
  /// -> auto | array
  size: auto, 

  /// Marker colors. The element may either be of type `color` (then the argument 
  /// `map` will be ignored) or of type `float`. In the case of the latter, the 
  /// colors will be determined by normalizing the values and passing them through the 
  /// `map`.
  /// -> auto | color | array
  color: auto,

  /// A color map in form of a gradient or an array of colors to sample from when 
  /// @scatter.color is given as `float` values.  
  /// -> array | gradient
  map: color.map.viridis,

  /// Sets the data value that corresponds to the first color of the color map. If set 
  /// to `auto`, it defaults to the minimum value of @scatter.color.
  /// -> auto | int | float
  vmin: auto,

  /// Sets the data value that corresponds to the last color of the color map. If set 
  /// to `auto`, it defaults to the maximum value of @scatter.color.
  /// -> auto | int | float
  vmax: auto,

  /// The normalization method used to scale scalar @scatter.color values to the range 
  /// $[0,1]$ before mapping them to colors using the color map. This can be a 
  /// `lq.scale`, a string that is the identifier of a built-in scale or a function 
  /// that takes one argument. 
  /// -> lq.scale | str | function
  norm: "linear",

  /// The mark to use to mark data points. See @plot.mark. 
  /// -> auto | lq.mark | string
  mark: auto, 

  /// Marker stroke. TODO: need to get rid of it
  stroke: 1pt,

  /// The fill opacity. TODO: maybe get rid of it, there is already color. 
  /// -> ratio | array
  alpha: 100%,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Whether to clip the plot to the data area. See @plot.clip. 
  /// -> boolean
  clip: true,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2,
  
) = {
  assertations.assert-matching-data-dimensions(x, y, fn-name: "scatter")
  
  
  if type(size) == array { 
    assert.eq(x.len(), size.len(), message: "Input dimensions for x (" + str(x.len()) + ") and size (" + str(size.len()) + ") don't match")
    let size-type = type(size.at(0, default: 0))
    if size-type in (int, float) {
      size = size.map(x => calc.sqrt(x) * 1pt)
    }
  }
  let cinfo
  if type(color) == array { 
    assert.eq(x.len(), color.len(), message: "Input dimensions for coordinates (" + str(x.len()) + ") and color (" + str(color.len()) + ") don't match")
    
    if type(color.at(0, default: 0)) in (int, float) {
      if type(map) == array {
        map = gradient.linear(..map)
      }
      (color, cinfo) = create-normalized-colors(color, map, norm, ignore-nan: false, vmin: vmin, vmax: vmax)
    }
  }
  (
    cinfo: cinfo,
    x: x,
    y: y,
    size: size,
    color: color, 
    alpha: alpha,
    label: label,
    style: (
      mark: mark,
      stroke: stroke,
      map: map,
    ),
    plot: render-scatter,
    xlimits: () => minmax(x),
    ylimits: () => minmax(y),
    legend-handle: plot => none,
    new-legend: true, 
    clip: clip,
    z-index: z-index
  )
}

