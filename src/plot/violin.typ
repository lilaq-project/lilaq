#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark, resolve-mark
#import "../utility.typ"
#import "../logic/time.typ"
#import "../style/styling.typ": prepare-path
#import "../math.typ": minmax
#import "../process-styles.typ": process-plot-item-width


#import "@preview/elembic:1.1.1" as e

// A median mark of a violin plot
#let violin-median = e.element.declare(
  "violin-median",
  prefix: "lilaq",
  display: it => mark(),
  fields: ()
)
// A mean mark of a violin plot
#let violin-mean = e.element.declare(
  "violin-mean",
  prefix: "lilaq",
  display: it => mark(),
  fields: ()
)

#let render-violin(
  style, data, x, width, transform, legend: false,
  horizontal: false
) = {
  

  let tt((p, d)) = transform(d, p)
  
  let prepare-path = prepare-path.with(
    fill: style.fill,
    stroke: style.stroke,
    element: curve,
  )

  if legend {
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

  let style = style


  for (i, data) in data.enumerate() {
    let center = x.at(i)
    let width = width.at(i)
    let (x: positions, y: density) = data.kde
    positions = (positions.first(),) + positions + (positions.last(),)
    density = (0,) + density + (0,)

    let max-density = calc.max(..density)

    if max-density > 0 {
      density = density.map(y => y / max-density * width / 2)

      let vertices = ()

      if style.side in ("low", "both") {
        vertices += positions
          .zip(density.map(d => center - d))
          .map(tt)
      }
      if style.side in ("high", "both") {
        vertices += positions
          .zip(density.map(d => center + d))
          .map(tt)
          .rev()
      }
      if horizontal {
        vertices = vertices.map(array.rev)
      }

      place(curve(
        curve.move(vertices.first()),
        ..vertices.slice(1).map(curve.line),
        curve.close(),
      ))
    }


    let statistics = data.boxplot-statistics
    let boxplot-width = style.boxplot-width

    // Pre-transform width, i.e., in data coordinates
    let pre-width = utility.match-type(
      boxplot-width,
      length: () => 0,
      ratio: () => width * boxplot-width / 100%,
      default: () => boxplot-width,
    )
    // Post-transform width, i.e., in pt
    let post-width = utility.match-type(
      boxplot-width,
      length: () => boxplot-width,
      default: 0pt,
    )

    let shift = utility.match(
      style.side,
      "low",
      -1,
      "both",
      0,
      "high",
      1,
    )
    
    center += shift * pre-width / 2

    let (low-pt, q1-pt) = transform(center + pre-width / 2, statistics.q1)
    let (high-pt, q3-pt) = transform(center - pre-width / 2, statistics.q3)
    let (center-pt, median-pt) = transform(center, statistics.median)
    let (_, whisker-low-pt) = transform(center, statistics.whisker-low)
    let (_, whisker-high-pt) = transform(center, statistics.whisker-high)

    let coeff = if transform(center - 1, 1).at(0) < transform(center + 1, 1).at(0) { 1 } else { -1 }
    low-pt += coeff * (shift - 1) * post-width / 2
    high-pt += coeff * (shift + 1) * post-width / 2
    center-pt += coeff * shift * post-width / 2
    


    show: prepare-path.with(
      fill: style.boxplot-fill,
      stroke: style.boxplot-stroke,
      element: curve,
    )

    // reverse coordinates for hviolin
    let hreverse = if horizontal { array.rev } else { a => a }


    if style.boxplot {
      place(curve(
        curve.move(hreverse((center-pt, q1-pt))),
        curve.line(hreverse((center-pt, whisker-low-pt))),
        curve.move(hreverse((center-pt, q3-pt))),
        curve.line(hreverse((center-pt, whisker-high-pt))),
        curve.move(hreverse((low-pt, q1-pt))),
        curve.line(hreverse((high-pt, q1-pt))),
        curve.line(hreverse((high-pt, q3-pt))),
        curve.line(hreverse((low-pt, q3-pt))),
        curve.close(),
      ))
    }

    let mark-value(style, pos, mark-type) = {
      if style == none { return }

      let (_, y) = transform(center, pos)
      if type(style) in (color, length, stroke, dictionary) {
        set curve(stroke: style)
        place(curve(
          curve.move(hreverse((low-pt, y))),
          curve.line(hreverse((high-pt, y))),
          stroke: (cap: "square")
        ))
      } else {
        show: prepare-mark.with(func: style, fill: white)
        let (x, y) = hreverse((center-pt, y))
        place(dx: x, dy: y, mark-type())
      }
    }

    mark-value(style.median, statistics.median, violin-median)
    mark-value(style.mean, statistics.mean, violin-mean)
  }
}


#let process-data(
  data,
  bandwidth,
  num-points,
  trim: true,
  whisker-pos: 1.5,
) = {
  import "@preview/komet:0.2.0"

  data
    .filter(dataset => dataset.len() > 0)
    .map(dataset => {
      assert(
        type(dataset) == array,
        message: "Each violin plot dataset must be an array",
      )

      let boxplot-statistics = komet.boxplot(
        dataset,
        whisker-pos: whisker-pos,
      )

      let args = (bandwidth: bandwidth, num-points: num-points)
      if trim {
        args.min = boxplot-statistics.min
        args.max = boxplot-statistics.max
      }
      let kde = komet.kde(
        dataset,
        ..args,
      )

      (
        kde: kde,
        boxplot-statistics: boxplot-statistics,
        limits: (kde.x.first(), kde.x.last()),
      )
    })
}

/// Computes and visualizes one or more violin plots from a series of datasets.
///
/// A violin plot is similar to a boxplot but uses kernel density estimation
/// to visualize the distribution of the data. The width of the violin represents the density of data points at
/// the $y$-coordinate. 
/// 
/// ```example
/// #lq.diagram(
///   lq.violin(
///     (0, 2, 3, 4, 5, 6, 7, 8, 3, 4, 4, 2, 12),
///     (1, 3, 4, 5, 5, 5, 5, 6, 7, 12),
///     (0, 3, 4, 5, 6, 7, 8, 9),
///   )
/// )
/// ```
#let violin(

  /// One or more data sets to generate violin plots from. Each dataset should
  /// be an array of numerical values.
  /// -> array
  ..data,

  /// The $x$ coordinate(s) to draw the violin plots at. If set to `auto`, 
  /// plots will be created at integer positions starting with 1. 
  /// -> auto | int | float | array
  x: auto,

  /// Width of the violins. See @bar.width. 
  /// -> ratio | int | float | duration | array
  width: 50%,

  /// Bandwidth for kernel density estimation. The bandwidth can drastically 
  /// influence the appearance and its selection needs good care. If set to 
  /// `auto`, Scott's rule is used (D.W. Scott, "Multivariate Density 
  /// Estimation: Theory, Practice, and Visualization", 1992).
  /// ```example
  /// #let data = (2, 1.5, 1.4, 1, .4, .6, .5, -.5)
  /// 
  /// #lq.diagram(
  ///   lq.violin(data, bandwidth: auto),
  ///   lq.violin(data, x: 2, bandwidth: .2),
  ///   lq.scatter((1.5,) * data.len(), data)
  /// )
  /// ```
  /// -> auto | int | float
  bandwidth: auto,

  /// How to fill the violins. If a `ratio` is given, the automatic color from 
  /// style cycle is lightened (for values less than 100%) or darkened (for 
  /// values greater than 100%). A value of `0%` produces white and a value of 
  /// `200%` produces black. 
  /// -> auto | none | color | gradient | tiling | ratio
  fill: 30%,

  /// How to stroke the violin outline. 
  /// -> none | length | color | stroke | gradient | tiling | dictionary
  stroke: auto,

  /// Number of points (i.e., the resolution) for the kernel density estimation.
  /// -> int
  num-points: 80,

  /// Whether and how to display the median value. It can be visualized with a 
  /// mark (see @plot.mark) or a horizontal line. 
  /// ```example
  /// #lq.diagram(
  ///   width: 3cm,
  ///   lq.violin((0, 2, 3, 4, 7), median: white),
  /// )
  /// ```
  /// -> none | lq.mark | str | color | stroke | length
  median: "o",
  
  /// Which side to plot the KDE at. 
  /// ```example
  /// #lq.diagram(
  ///   lq.violin(
  ///     (0, 2, 3, 4, 7), 
  ///     (2, 2, 3, 5, 8), 
  ///     side: "low"
  ///   ),
  ///   lq.violin(
  ///     (1, 3, 8, 4, 2), 
  ///     (3, 4, 3, 7, 9), 
  ///     side: "high"
  ///   ),
  /// )
  /// ```
  /// -> "both" | "low" | "high"
  side: "both",

  mean: none,

  /// Whether to display a boxplot inside KDE. 
  /// -> bool
  boxplot: true,

  /// The width of the boxplot inside the violin plot. This can be
  /// - an `int` or `float` to specify the width in data coordinates,
  /// - a `ratio` to give the width relative to @violin.width,
  /// - or an absolute and fixed `length`. 
  /// -> int | float | ratio | length
  boxplot-width: 15%,

  /// How to fill the boxplot. 
  /// -> auto | none | color | gradient | tiling | ratio
  boxplot-fill: auto,

  /// How to stroke the boxplot. 
  /// -> none | length | color | stroke | gradient | tiling | dictionary
  boxplot-stroke: auto,

  /// The position of the whiskers. See @boxplot.whisker-pos. 
  /// -> int | float
  whisker-pos: 1.5,

  /// Whether to trim the density to the datasets minimum and maximum value. 
  /// If set to `false`, the range is automatically enhanced, depending on the 
  /// bandwidth. 
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

  if type(x) in (int, float, datetime) { x = (x,) } else if x == auto {
    x = range(1, num-violins + 1)
  }

  let datetime-axes = (:)
  if type(x.at(0, default: 0)) == datetime {
    x = time.to-seconds(..x)
    datetime-axes.x = true
  }


  width = process-plot-item-width(width, x)

  assert(
    x.len() == num-violins,
    message: "The number of x coordinates does not match the number of data arrays",
  )

  assert(
    width.len() == num-violins,
    message: "The number of widths does not match the number of data arrays",
  )

  let processed-data = process-data(
    data,
    bandwidth,
    num-points,
    trim: trim,
    whisker-pos: whisker-pos,
  )

  let (ymin, ymax) = minmax(
    processed-data.map(info => info.limits).flatten(),
  )
  let (xmin, xmax) = (x.at(0) - width.at(0) / 2, x.at(-1) + width.at(-1) / 2)

  if processed-data.len() == 0 {
    (xmin, xmax) = (none, none)
  }

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
      side: side,
      boxplot: boxplot,
      boxplot-width: boxplot-width,
      boxplot-fill: boxplot-fill,
      boxplot-stroke: boxplot-stroke,
    ),
    plot: (plot, transform) => render-violin(
      plot.style,
      plot.data,
      plot.x,
      plot.width,
      (x, y) => transform(x, y),
      legend: "make-legend" in plot
    ),
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    ignores-cycle: false,
    clip: clip,
    z-index: z-index,
  )
}
