#import "../assertations.typ"
#import "../plot-utils.typ": merge-strokes, merge-fills, bar-lim
#import "../process-points.typ": filter-nan-points
#import "../math.typ": minmax
#import "../utility.typ": if-auto
#import "../cycle.typ": mark, prepare-mark, prepare-path

#let render-stem(plot, transform) = {
  let marker = plot.style.mark
  let marker = mark()
  
  // set path(stroke: plot.style.line)
  
  let (xmin, xmax) = (plot.xlimits)()
  
  if "make-legend" in plot {
    xmin = 0
    xmax = 1
    plot.x = (.5,)
    plot.y = (.8,)
    plot.base = 0
  }
  
  let (x1, y0) = transform(xmin, plot.base)
  let (x2, y0) = transform(xmax, plot.base)

  

  
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
    place(std.path((xx, y0), (xx, yy)))
    place(dx: xx, dy: yy, marker)
  }
  if plot.style.base-stroke != none {
    place(line(start: (x1, y0), end: (x2, y0), stroke: plot.style.base-stroke))
  }
}




/// Creates a (vertical) stem plot. 
#let stem(
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
  /// -> lq.mark | string
  mark: auto, 
  
  /// Size of the markers. 
  /// -> length
  mark-size: 5pt,
  
  /// Color of the markers (takes precedence over @stem.color). 
  /// -> auto | color
  mark-color: auto,
  
  /// Defines the $y$ coordinate of the base line.
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
  assertations.assert-matching-data-dimensions(x, y, fn-name: "stem")
  (
    x: x,
    y: y,
    base: base,
    label: label,
    style: (
      mark: mark,
      color: color,
      mark-size: mark-size,
      mark-color: merge-fills(mark-color, color),
      line: merge-strokes(line, color),
      base-stroke: base-stroke
    ),
    plot: render-stem,
    xlimits: () => minmax(x),
    ylimits: () => bar-lim(y, (base,)),
    // legend-handle: plot => {
    //   let y1 = plot.style.mark-size / 4
    //   place(std.line(start: (50%, y1), end: (50%, 100%), stroke: plot.style.line))
    //   place(dx: 50%, dy: y1, (plot.style.mark)(plot.style))
    //   if plot.style.base-stroke != none {
    //     place(std.line(start: (0pt, 100%), end: (100%, 100%), stroke: plot.style.base-stroke))
    //   }
    // },
    legend-handle: plot => none,
    new-legend: true,
    clip: clip,
    z-index: z-index
  )
}

