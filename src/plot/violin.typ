#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark
#import "../utility.typ"
#import "../logic/time.typ"
#import "../style/styling.typ": prepare-path
#import "../math.typ": minmax
#import "../process-styles.typ": process-plot-item-width


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
    pos = (pos.first(),) + pos + (pos.last(),)
    density = (0,) + density + (0,)

    let max-density = calc.max(..density)
    if max-density > 0 {
      density = density.map(y => y / max-density * width / 2)

      let points = ()

      if plot.style.side in ("low", "both") {
        points += pos.zip(density).map(((pos, d)) => transform(x - d, pos))
      }
      if plot.style.side in ("high", "both") {
        points += pos
          .zip(density)
          .map(((pos, d)) => transform(x + d, pos))
          .rev()
      }

      place(curve(
        curve.move(points.first()),
        ..points.slice(1).map(curve.line),
        curve.close(),
      ))
    }


    let statistics = data.boxplot-statistics
    let boxplot-width = plot.style.boxplot-width

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
      plot.style.side,
      "low",
      -1,
      "both",
      0,
      "high",
      1,
    )
    x += shift * pre-width / 2
    let (x1, q1) = transform(x + pre-width / 2, statistics.q1)
    let (x2, q3) = transform(x - pre-width / 2, statistics.q3)
    let (middle, median) = transform(x, statistics.median)
    x1 += (shift - 1) * post-width / 2
    x2 += (shift + 1) * post-width / 2
    middle += shift * post-width / 2
    let (_, whisker-low) = transform(x, statistics.whisker-low)
    let (_, whisker-high) = transform(x, statistics.whisker-high)


    show: prepare-path.with(
      fill: style.boxplot-fill,
      stroke: style.boxplot-stroke,
      element: curve,
    )

    if style.boxplot {
      place(curve(
        curve.move((middle, q1)),
        curve.line((middle, whisker-low)),
        curve.move((middle, q3)),
        curve.line((middle, whisker-high)),
        curve.move((x1, q1)),
        curve.line((x2, q1)),
        curve.line((x2, q3)),
        curve.line((x1, q3)),
        curve.close(),
      ))
    }

    let mark-value(style, y) = {
      if style == none { return }
      let (_, y) = transform(x, y)
      if type(style) in (color, length) {
        set curve(stroke: style)
        set curve(stroke: (cap: "square"))
        place(curve(
          curve.move((x1, y)),
          curve.line((x2, y)),
        ))
      } else {
        show: prepare-mark.with(
          func: style,
          size: plot.style.mark-size,
          fill: white,
        )

        place(dx: middle, dy: y, mark())
      }
    }

    mark-value(style.median, statistics.median)
    mark-value(style.mean, statistics.mean)
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
  /// #let data = (2, 1.5, 1.4, .9, .8, 1, .4, .6, .5, -.5)
  /// 
  /// #lq.diagram(
  ///   lq.violin(data, bandwidth: auto),
  ///   lq.violin(data, x: 2, bandwidth: .2),
  ///   lq.scatter((1.5,) * data.len(), data)
  /// )
  /// ```
  /// -> none | lq.mark | str | color | stroke | length
  median: "o",
  
  /// Which side to plot the KDE at. 
  /// ```example
  /// 
  /// ```
  /// -> "both" | "low" | "high"
  side: "both",

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

  /// Whether to display a boxplot inside KDE. 
  /// -> bool
  boxplot: true,

  /// The width of the boxplot inside the violin plot. This can be
  /// - an `int` or `float` to specify the width in data coordinates,
  /// - a `ratio` to give the width relative to @violin.width,
  /// - or an absolute and fixed `length`. 
  /// -> int | float | ratio | length
  boxplot-width: 20%,

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
      mark-size: mean-size,
      mean-fill: mean-fill,
      mean-stroke: mean-stroke,
      side: side,
      boxplot: boxplot,
      boxplot-width: boxplot-width,
      boxplot-fill: boxplot-fill,
      boxplot-stroke: boxplot-stroke,
    ),
    plot: render-violin,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    ignores-cycle: false,
    clip: clip,
    z-index: z-index,
  )
}
