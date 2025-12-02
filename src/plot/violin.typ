#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark
#import "../logic/time.typ"
#import "../style/styling.typ": prepare-path
#import "../math.typ": minmax


#let render-violin(plot, transform) = {
  let prepare-path = prepare-path.with(
    fill: plot.style.fill,
    stroke: plot.style.stroke,
    element: curve,
  )

  if "make-legend" in plot {
    return {
      show: prepare-path
      curve(
        curve.line((0%, 100%)),
        curve.line((100%, 100%)),
        curve.line((100%, 0%)),
        curve.close(),
      )
    }
  }
  show: prepare-path

  let style = plot.style


  for (i, data) in plot.data.enumerate() {
    let x = plot.x.at(i)
    let width = plot.width.at(i)

    let (x: pos, y: density) = data.kde

    // Normalize the KDE values to fit within the width
    let max-density = calc.max(..density)
    if max-density > 0 {
      density = density.map(y => y / max-density * width / 2)

      let left-points = pos
        .zip(density)
        .map(((pos, d)) => transform(x - d, pos))
      let right-points = pos
        .zip(density)
        .map(((pos, d)) => transform(x + d, pos))
      let points = left-points + right-points.rev()

      place(curve(
        curve.move(points.first()),
        ..points.slice(1).map(curve.line),
        curve.close(),
      ))
    }




    let statistics = data.boxplot-statistics


    if style.median != none {
      show: prepare-mark.with(
        func: style.median,
        size: style.mark-size,
        fill: white,
      )

      let (median-x, median-y) = transform(x, statistics.median)
      place(dx: median-x, dy: median-y, mark())
    }
    if style.mean != none {
      let (mean-x, mean-y) = transform(x, statistics.mean)

      show: prepare-mark.with(
        func: style.mean,
        size: style.mark-size,
        fill: white,
      )
      set mark(stroke: style.mean-stroke)
      place(dx: mean-x, dy: mean-y, mark())
    }
  }
}


#let process-data(
  data, 
  bandwidth,
  num-points,
  trim: true
) = {
  import "@preview/komet:0.2.0"

  data.map(dataset => {
    assert(type(dataset) == array, message: "Each violin plot dataset must be an array")

    let boxplot-statistics = komet.boxplot(
      dataset
    )
    
    let args = (bandwidth: bandwidth, num-points: num-points)
    if trim {
      args.min = boxplot-statistics.min
      args.max = boxplot-statistics.max
    }
    let kde = komet.kde(
      dataset,
      ..args
    )
    
    (
      kde: kde,
      boxplot-statistics: boxplot-statistics,
      limits: (kde.x.first(), kde.x.last())
    )
  })
}

/// Computes and visualizes one or more violin plots from datasets. 
/// 
/// A violin plot is similar to a boxplot but uses kernel density estimation 
/// to show the distribution of the data. The width of the violin at each 
/// y-value represents the density of data points at that value.
/// 
/// ```example
/// #lq.diagram(
///   lq.violin(
///     (1, 2, 3, 4, 5, 6, 7, 8, 9),
///     range(1, 20),
///     (1, 28, 25, 30),
///   )
/// )
/// ```
/// 
/// You can customize the appearance:
/// ```example
/// #lq.diagram(
///   lq.violin(
///     (1, 3, 10, 15, 8, 6, 4), 
///     fill: blue.lighten(60%), 
///     stroke: blue.darken(30%),
///     mean: "x"
///   ),
/// )
/// ```
#let violin(

  /// One or more data sets to generate violin plots from. Each dataset should be
  /// an array of numerical values.
  /// -> array
  ..data,

  /// The $x$ coordinate(s) to draw the violin plots at. If set to `auto`, plots will 
  /// be created at integer positions starting with 1. 
  /// -> auto | int | float | array
  x: auto,

  /// The width of the violin plots in $x$ data coordinates. This can be a constant width
  /// applied to all plots or an array of widths matching the number of data sets. 
  /// -> int | float | array
  width: 0.5,

  /// How to fill the violins. 
  /// -> auto | none | color | gradient | tiling
  fill: auto,

  /// How to stroke the violin outline. 
  /// -> none | length | color | stroke | gradient | tiling | dictionary
  stroke: none,

  /// Bandwidth for kernel density estimation. If `auto`, uses Scott's rule.
  /// -> auto | int | float
  bandwidth: auto,

  /// Number of points to evaluate the density at.
  /// -> int
  num-points: 100,

  /// Whether and how to display the mean value. The mean can be 
  /// visualized with a mark (see @plot.mark).
  /// -> none | lq.mark | str
  mean: none,
  
  median: "o",

  /// The size of the mark used to visualize the mean. 
  /// -> length
  mean-size: 5pt,
  
  /// How to fill the mean mark. 
  /// -> none | auto | color
  mean-fill: black,
  
  /// How to stroke the mean mark. 
  /// -> stroke
  mean-stroke: black,

  /// Whether to trim the density to the datasets minimum and maximum value. If set to false, the range is automatically enhanced, depending on the bandwidth. 
  /// -> bool
  trim: true,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Whether to clip the plot to the data area. See @plot.clip. 
  /// -> bool
  clip: true,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram
  /// objects. See @plot.z-index.  
  /// -> int | float
  z-index: 2,
  
) = {
  assertations.assert-no-named(data)
  data = data.pos()
  let num-violins = data.len()
  
  if type(x) in (int, float, datetime) { x = (x,) }
  else if x == auto { x = range(1, num-violins + 1) }

  let datetime-axes = (:)
  if type(x.at(0, default: 0)) == datetime {
    x = time.to-seconds(..x)
    datetime-axes.x = true
  }

  assert(
    x.len() == num-violins, 
    message: "The number of x coordinates does not match the number of data arrays"
  )
  
  if type(width) in (int, float) { width = (width,) * num-violins }
  assert(
    width.len() == num-violins, 
    message: "The number of widths does not match the number of data arrays"
  )
  
  let processed-data = process-data(data, bandwidth, num-points, trim: trim)

  let (ymin, ymax) = minmax(
    processed-data.map(info => info.limits).join()
  )
  let xmin = x.at(0) - width.at(0)
  let xmax = x.at(-1) + width.at(-1)

  (
    x: x,
    data: processed-data,
    label: label,
    width: width,
    style: (
      fill: fill,
      stroke: stroke,
      mean: mean,
      median: median,
      mark-size: mean-size,
      mean-fill: mean-fill,
      mean-stroke: mean-stroke,

      whisker: 1pt
    ),
    plot: render-violin,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    ignores-cycle: false,
    clip: clip,
    z-index: z-index
  )
}
