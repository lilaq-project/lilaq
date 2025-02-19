#import "../assertations.typ"
#import "../utility.typ": match
#import "../algorithm/boxplot.typ": *
#import "../utility.typ"
#import "../cycle.typ": mark, prepare-mark

#let render-boxplot(plot, transform) = {
  let style = plot.style
  let get-bar-range(i) = (
    plot.width.at(i) * -.5, plot.width.at(i) * (1 + -.5)
  )

  let box-thickness = utility.if-auto(stroke(style.stroke).thickness, 1pt)
  
  for (i, statistics) in plot.statistics.enumerate() {

    let (x1, x2) = get-bar-range(i)
    let x = plot.x.at(i)

    
    
    let (xx1, q1) = transform(x + x1, statistics.q1)
    let (xx2, q3) = transform(x + x2, statistics.q3)
    let (middle, median) = transform(x, statistics.median)
    let (_, whisker-low) = transform(x, statistics.whisker-low)
    let (_, whisker-high) = transform(x, statistics.whisker-high)
    let (xm1, _) = transform(x - style.cap-length/2, statistics.q1)
    let (xm2, _) = transform(x + style.cap-length/2, statistics.q1)

    
    place(line(start: (middle, q1), end: (middle, whisker-low), stroke: style.whisker))
    place(line(start: (middle, q3), end: (middle, whisker-high), stroke: style.whisker))
    place(line(start: (xm1, whisker-low), end: (xm2, whisker-low), stroke: style.cap))
    place(line(start: (xm1, whisker-high), end: (xm2, whisker-high), stroke: style.cap))

    place(
      dx: xx1, dy: q1,
      rect(height: q3 - q1, width: xx2 - xx1, fill: style.fill, stroke: style.stroke)
    )
    
    place(line(start: (xx1 + box-thickness/2, median), end: (xx2 - box-thickness/2, median), stroke: style.median))
    
    if style.mean != none {
      
      let (_, mean) = transform(x, statistics.mean)
      if type(style.mean) in (str, function) {
        show: prepare-mark.with(
          func: plot.style.mean,
          size: plot.style.mark-size,
          fill: plot.style.outlier-fill
        )
        set mark(stroke: plot.style.outlier-stroke)
        place(dx: middle, dy: mean, mark())
      } else {
        place(line(start: (xx1 + box-thickness/2, mean), end: (xx2 - box-thickness/2, mean), stroke: style.mean))
      }
    }
    if plot.style.mark != none {
      
      show: prepare-mark.with(
        func: plot.style.mark,
        size: plot.style.mark-size,
        fill: plot.style.outlier-fill
      )
      set mark(stroke: plot.style.outlier-stroke)
      for outlier in statistics.outliers {
        let (_, y) = transform(x + x1, outlier)
        place(dx: middle, dy: y, mark())
      }
    }
    
  }
}

/// Computes and visualizes one or more boxplots from the given data. 
/// 
/// ```example
/// #lq.diagram(
///   lq.boxplot(
///     stroke: blue.darken(50%), 
///     (
///       (1, 2, 3, 4, 5, 6, 7, 8, 9, 21, 19),
///       range(1, 30),
///       (1, 28, 25, 30),
///       (1, 2, 3, 4, 5, 6, 32),
///     )
///   )
/// )
/// ```
#let boxplot(

  /// One or more data arrays to generate a boxplot from. If a single data array 
  /// is given, one boxplot is created. If `data` is two-dimensional, a boxplot is 
  /// created for each array. 
  /// -> array
  data,

  /// The $x$ coordinate(s) to draw the boxplots at. If set to `auto`, boxplots will 
  /// be created at integer positions starting with 1. 
  /// auto | int | float | array
  x: auto,

  /// The position of the whiskers. The length of the whiskers is at most 
  /// `whisker-pos*(q3 - q1)` where `q1` and `q3` are the first and third quartils. 
  /// However, the whiskers always end at an actual data point, so the length can be 
  /// less then that. The default value of 1.5 is a very common convention established 
  /// by John Tukey in _Exploratory data analysis_ (1977).
  /// -> int | float
  whisker-pos: 1.5,

  /// The width of the boxplots in $x$ data coordinates. This can be a constant width
  /// applied to all boxplots or an array of individual widths. 
  /// -> int | float | array
  width: .5,

  /// The length of the whisker caps in $x$ data coordinates. 
  /// -> int | float
  cap-length: .25,

  /// How to fill the boxes. 
  /// -> none | color | gradient | pattern
  fill: none,

  /// How to stroke the boxplot. 
  /// -> length | color | stroke | gradient | pattern | dictionary
  stroke: 1pt + black,

  /// How to stroke the line indicating the median of the data. 
  /// -> length | color | stroke | gradient | pattern | dictionary
  median: 1pt + orange,

  /// Whether and how to display the mean value which is not shown by default.
  /// The mean value can be visualized with a mark (see @plot.mark) or a line 
  /// like the median. 
  /// -> none | lq.mark | str | stroke 
  mean: none,

  /// How to stroke the whiskers. If set to `auto`, the stroke is inherited from 
  /// @boxplot.stroke. 
  /// -> length | color | stroke | gradient | pattern | dictionary
  whisker: auto,


  /// How to stroke the caps of the whiskers. If set to `auto`, the stroke is inherited 
  /// from @boxplot.stroke.   
  /// -> length | color | stroke | gradient | pattern | dictionary
  cap: auto,

  /// Whether to display outliers.
  /// -> none | lq.mark | str 
  outliers: "o",

  /// The size of the marks used to visualize outliers. 
  /// -> length
  outlier-size: 5pt,
  
  /// The color of the marks used to visualize outliers. 
  /// -> none | color
  outlier-fill: none,
  
  /// The color of the marks used to visualize outliers. 
  /// -> stroke
  outlier-stroke: black,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Whether to clip the plot to the data area. See @plot.clip. 
  /// -> bool
  clip: true,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2,
  
) = {
  if type(data) == array and type(data.first()) in (float, int) {
    data = (data,)
  }
  let num-boxplots = data.len()
  
  if type(x) in (int, float) { x = (x,) }
  if x == auto { x = range(1, num-boxplots + 1) }
  assert(x.len() == num-boxplots, message: "The number of x coordinates does not match the number of data arrays")
  
  if type(width) in (int, float) { width = (width,) * num-boxplots }
  assert(width.len() == num-boxplots, message: "The number of widths does not match the number of data arrays")
  
  if whisker == auto { whisker = utility.if-none(stroke, std.stroke()) }
  if cap == auto { cap = utility.if-none(stroke, std.stroke()) }
  
  let statistics = data.map(boxplot-statistics.with(whiskers: whisker-pos))
  let all-outliers = ()
  if outliers != none {
    all-outliers = statistics.map(boxplot => boxplot.outliers).flatten()
  }
  let ymax = calc.max(..statistics.map(x => x.whisker-high), ..all-outliers)
  let ymin = calc.min(..statistics.map(x => x.whisker-low), ..all-outliers)
  let xmin = x.at(0) - width.at(0)
  let xmax = x.at(-1) + width.at(-1)
  (
    x: x,
    statistics: statistics,
    label: label,
    width: width,
    style: (
      fill: fill,
      stroke: stroke,
      cap: cap,
      cap-length: cap-length,
      whisker: whisker,
      median: median,
      mean: mean,
      mark: if outliers != none { outliers },
      mark-size: outlier-size,
      outlier-fill: outlier-fill,
      outlier-stroke: outlier-stroke,
    ),
    plot: render-boxplot,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    legend-handle: plot => {
      std.line(length: 100%, stroke: red)
    },
    clip: clip,
    z-index: z-index
  )
}

