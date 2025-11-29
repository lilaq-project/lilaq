#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark
#import "../logic/time.typ"


#let render-violinplot(plot, transform) = {
  
  if "make-legend" in plot {
    return std.line(length: 100%, stroke: plot.style.stroke)
  }

  let style = plot.style

  for (i, data) in plot.data.enumerate() {
    let x = plot.x.at(i)
    let width = plot.width.at(i)
    
    // Get the KDE result for this dataset
    let kde-result = data.kde
    
    // Normalize the KDE values to fit within the width
    let max-density = calc.max(..kde-result.y)
    if max-density > 0 {
      let normalized-y = kde-result.y.map(y => y / max-density * width / 2)
      
      // Draw the violin shape (mirrored density curve)
      let left-points = ()
      let right-points = ()
      
      for (j, y-val) in kde-result.x.enumerate() {
        let density = normalized-y.at(j)
        let (xl, yl) = transform(x - density, y-val)
        let (xr, yr) = transform(x + density, y-val)
        left-points.push((xl, yl))
        right-points.push((xr, yr))
      }
      
      // Create closed path for the violin
      if left-points.len() > 0 {
        // Combine left and right points to form a closed shape
        right-points = right-points.rev()
        let all-points = left-points + right-points
        
        // Draw filled violin
        if style.fill != none {
          let path-cmds = (std.curve.move(all-points.at(0)),)
          for pt in all-points.slice(1) {
            path-cmds.push(std.curve.line(pt))
          }
          path-cmds.push(std.curve.close())
          place(std.curve(..path-cmds, fill: style.fill, stroke: none))
        }
        
        // Draw outline
        if style.stroke != none {
          let left-path = (std.curve.move(left-points.at(0)),)
          for pt in left-points.slice(1) {
            left-path.push(std.curve.line(pt))
          }
          place(std.curve(..left-path, stroke: style.stroke))
          
          let right-path = (std.curve.move(right-points.at(0)),)
          for pt in right-points.slice(1) {
            right-path.push(std.curve.line(pt))
          }
          place(std.curve(..right-path, stroke: style.stroke))
        }
      }
    }
    
    // Draw mean marker if requested
    if style.mean != none and "mean" in data {
      let (_, mean-y) = transform(x, data.mean)
      let (mean-x, _) = transform(x, 0)
      
      show: prepare-mark.with(
        func: style.mean,
        size: style.mark-size,
        fill: style.mean-fill
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
///   lq.violinplot(
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
///   lq.violinplot(
///     (1, 3, 10, 15, 8, 6, 4), 
///     fill: blue.lighten(60%), 
///     stroke: blue.darken(30%),
///     mean: "x"
///   ),
/// )
/// ```
#let violinplot(

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
  width: 0.8,

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
  mean-stroke: none,
  
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
  import "@preview/komet:0.1.0"
  let processed-data = ()
  let all-values = ()
  
  for dataset in data {
    assert(type(dataset) == array, message: "Each violin plot dataset must be an array")
    all-values += dataset
    
    let kde-result = komet.kde(
      dataset,
      bandwidth: bandwidth,
      num-points: num-points
    )
    
    let mean-value = dataset.fold(0.0, (acc, val) => acc + float(val)) / dataset.len()
    
    processed-data.push((
      kde: kde-result,
      mean: mean-value,
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
    plot: render-violinplot,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    clip: clip,
    z-index: z-index
  )
}
