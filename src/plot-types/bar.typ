#import "/src/assertations.typ"
#import "../plot-utils.typ": merge-fills, match, match-type, bar-lim
#import "../process-points.typ": filter-nan-points, stepify
#import "../math.typ": vec, minmax
#import "../cycle.typ": prepare-path


#let render-bar(plot, transform) = {
  
  let offset-coeff = plot.offset-coeff
    
  let get-bar-range = match-type(
    plot.width,
    int: () => i => (
        plot.width * offset-coeff, plot.width * (1 + offset-coeff),
      ),
    float: () => i => (
        plot.width * offset-coeff, plot.width * (1 + offset-coeff),
      ),
    array: () => i => (
        plot.width.at(i) * offset-coeff, plot.width.at(i) * (1 + offset-coeff),
      ),
  )
  


  show: prepare-path.with(
    fill: plot.style.fill,
    stroke: plot.style.stroke
  )

  if "make-legend" in plot {
    std.path(
      (0%, 0%), (0%, 100%), (100%, 100%), (100%, 0%), 
      closed: true
    )
  } else {
  
    for i in range(plot.x.len()) {
      let y = plot.y.at(i)
      if float.is-nan(y) { continue }
      
      let (x1, x2) = get-bar-range(i)
      let x = plot.x.at(i)
      
      let (xx1, y0) = transform(x + x1, plot.base.at(i, default: plot.base.first()))
      let (xx2, yy) = transform(x + x2, y)
      
      place(path(
        (xx1, y0), (xx1, yy), (xx2, yy), (xx2, y0), closed: true
      ))
    }
  }
}



/// Makes a bar plot from the given data. 
#let bar(
  
  /// An array of $x$ coordinates. 
  /// -> array
  x, 
  
  /// An array of $y$ coordinates. The number of $x$ and $y$ coordinates must match. 
  /// -> array
  y, 

  /// Fill color for the bars. 
  /// -> none | color | gradient | pattern
  fill: auto,

  /// Stroke style for the bars. 
  /// -> auto | none | color | length | stroke | gradient | pattern | dictionary
  stroke: none,

  /// Alignment of the bars at the $x$ values. 
  /// -> alignment
  align: center,

  /// Width of the bars in data coordinates. The width can be set either to a constant
  /// for all bars or individually by passing an array with the same length as the 
  /// coordinate arrays. 
  /// -> int | float | array
  width: .8,

  /// An offset to apply to all $x$ coordinates. This is equivalent to replacing
  /// the array passed to @bar.x with `x.map(x => x + offset)`. Using an offset
  /// can be useful to avoid overlaps when plotting multiple bar plots into one
  /// diagram. 
  /// -> int | float
  offset: 0,


  /// Defines the $y$ coordinate of the baseline of the bars. This can either be a 
  /// constant value applied to all bars or it can be set individually by passing an 
  /// array with the same length as the coordinate arrays. 
  /// -> int | float | array
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
  assertations.assert-matching-data-dimensions(x, y, width: width, base: base, fn-name: "bar")

  if offset != 0 {
    x = x.map(x => x + offset)
  }
  
  if type(base) in (int, float) {
    base = (base,)
  }
  
  let offset-coeff = match(
    align,
    left, 0, 
    center, -0.5, 
    right, -1
  )

  let simple-lims() = vec.add(
    minmax(x), 
    (offset-coeff*width, (1 + offset-coeff) * width)
  )
  
  let xlim = match-type(
    width,
    int: simple-lims,
    float: simple-lims,
    array: () => (
      calc.min(..x.zip(width).map(((x, w)) => x + offset-coeff*w)),
      calc.max(..x.zip(width).map(((x, w)) => x + (1 + offset-coeff) * w)),
    )
  )

  (
    x: x,
    y: y,
    width: width,
    offset-coeff: offset-coeff,
    label: label,
    base: base,
    style: (
      align: align,
      stroke: stroke,
      fill: fill
    ),
    plot: render-bar,
    xlimits: () => xlim,
    ylimits: () => bar-lim(y, base),
    legend-handle: plot => none,
    new-legend: true,
    clip: clip,
    z-index: z-index
  )
}

