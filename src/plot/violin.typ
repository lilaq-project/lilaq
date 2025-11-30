#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark
#import "../logic/time.typ"
#import "../style/styling.typ": prepare-path


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

    // Draw mean marker if requested
    if style.mean != none and "mean" in data {
      let (mean-x, mean-y) = transform(x, data.mean)

      show: prepare-mark.with(
        func: style.mean,
        size: style.mark-size,
        fill: style.mean-fill,
      )
      set mark(stroke: style.mean-stroke)
      place(dx: mean-x, dy: mean-y, mark())
    }
  }
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
  /// -> none | color | gradient | tiling
  fill: rgb(100, 150, 200, 50%),

  /// How to stroke the violin outline. 
  /// -> none | length | color | stroke | gradient | tiling | dictionary
  stroke: 1pt + black,

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

  /// The size of the mark used to visualize the mean. 
  /// -> length
  mean-size: 5pt,
  
  /// How to fill the mean mark. 
  /// -> none | auto | color
  mean-fill: black,
  
  /// How to stroke the mean mark. 
  /// -> stroke
  mean-stroke: black,
  
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
  
  // Compute KDE for each dataset
  // TODO: This needs to be updated to use the new komet version with KDE
  import "@local/komet:0.2.0"
  let processed-data = ()
  let all-values = ()
  
  for dataset in data {
    assert(type(dataset) == array, message: "Each violin plot dataset must be an array")

    let boxplot-statistics = komet.boxplot(
      dataset
    )
    
    let kde-result = komet.kde(
      dataset,
      bandwidth: bandwidth,
      num-points: num-points
    )
    all-values += kde-result.x
    
    processed-data.push((
      kde: kde-result,
      boxplot-statistics: boxplot-statistics,
    ))
  }

  let ymax = calc.max(..all-values)
  let ymin = calc.min(..all-values)
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
      mark-size: mean-size,
      mean-fill: mean-fill,
      mean-stroke: mean-stroke,
    ),
    plot: render-violin,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    clip: clip,
    z-index: z-index
  )
}
