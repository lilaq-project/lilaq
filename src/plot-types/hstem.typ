#import "../assertations.typ"
#import "../plot-utils.typ": merge-strokes, merge-fills, bar-lim
#import "../process-points.typ": filter-nan-points
#import "../math.typ": minmax
#import "../utility.typ": if-auto
#import "../cycle.typ": mark, prepare-mark, prepare-path



#let render-hstem(plot, transform) = {
  // let mark = plot.style.mark
  let marker = mark()
  set line(stroke: plot.style.line)

  let (ymin, ymax) = (plot.ylimits)()
  
  if "make-legend" in plot {
    ymin = 0
    ymax = 1
    plot.x = (.75,)
    plot.y = (.5,)
    plot.base = .25
  }
  
  let (x0, y1) = transform(plot.base, ymin)
  let (x0, y2) = transform(plot.base, ymax)

  

  
  show: prepare-mark.with(
    func: plot.style.mark, 
    color: merge-fills(plot.style.color),
    size: plot.style.mark-size
  )
  show: prepare-path.with(
    stroke: merge-strokes(plot.style.line, plot.style.color)
  )
  
  for (x, y) in filter-nan-points(plot.x.zip(plot.y)) {
    let (xx, yy) = transform(x, y)
    place(path((x0, yy), (xx, yy)))
    place(dx: xx, dy: yy, marker)
  }
  if plot.style.base-stroke != none {
    place(line(start: (x0, y1), end: (x0, y2), stroke: plot.style.base-stroke))
  }
}


/// Creates a horizonal stem plot. 
#let hstem(
  /// An array of $x$ coordinates. 
  /// -> array
  x, 
  
  /// An array of $y$ coordinates. The number of $x$ and $y$ coordinates must match. 
  /// -> array
  y, 

  /// Combined color for line and markers. See also the parameters @stem.line and 
  /// @stem.mark-color which take precedence over `color`, if set. 
  /// -> auto | color
  color: auto,
  
  /// The line style to use for this plot (takes precedence over @stem.color). 
  /// -> auto | stroke
  line: auto, 

  /// How to stroke the base line. 
  /// -> stroke
  base-stroke: red,
  
  /// The mark to use to mark data points. See @plot.mark. 
  /// -> auto | lq.mark | string
  mark: auto, 
  
  /// Size of the markers. 
  /// -> length
  mark-size: 5pt,
  
  /// Color of the markers (takes precedence over @stem.color). 
  /// -> auto | color
  mark-color: auto,
  
  /// Defines the $x$ coordinate of the base line.
  /// -> int | float
  base: 0,
  
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
  assertations.assert-matching-data-dimensions(x, y, fn-name: "hstem")
  (
    x: x,
    y: y,
    base: base,
    label: label,
    style: (
      color: color,
      mark: mark,
      mark-size: mark-size,
      mark-color: merge-fills(mark-color, color),
      line: merge-strokes(line, color),
      base-stroke: base-stroke
    ),
    plot: render-hstem,
    xlimits: () => bar-lim(x, (base,)),
    ylimits: () => minmax(y),
    // legend-handle: plot => {
    //   let x0 = 25%
    //   let x1 = 75% - plot.style.mark-size / 4
    //   place(std.line(start: (x0, 50%), end: (x1, 50%), stroke: plot.style.line))
    //   place(dx: x1, dy: 50%, (plot.style.mark)(plot.style))
    //   if plot.style.base-stroke != none {
    //     place(std.line(start: (x0, 0pt), end: (x0, 100%), stroke: plot.style.base-stroke))
    //   }
    // },
    legend-handle: plot => none,
    new-legend: true,
    clip: clip,
    z-index: z-index
  )
}
