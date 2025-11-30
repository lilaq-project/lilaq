#import "../assertations.typ"
#import "../style/styling.typ": mark, prepare-mark
#import "../logic/time.typ"


#let render-hviolin(plot, transform) = {
  
  if "make-legend" in plot {
    return std.line(length: 100%, stroke: plot.style.stroke)
  }

  let style = plot.style

  for (i, data) in plot.data.enumerate() {
    let y = plot.y.at(i)
    let width = plot.width.at(i)
    
    // Get the KDE result for this dataset
    let kde-result = data.kde
    
    // Normalize the KDE values to fit within the width
    let max-density = calc.max(..kde-result.y)
    if max-density > 0 {
      let normalized-y = kde-result.y.map(y => y / max-density * width / 2)
      
      // Draw the violin shape (mirrored density curve)
      let bottom-points = ()
      let top-points = ()
      
      for (j, x-val) in kde-result.x.enumerate() {
        let density = normalized-y.at(j)
        let (xb, yb) = transform(x-val, y - density)
        let (xt, yt) = transform(x-val, y + density)
        bottom-points.push((xb, yb))
        top-points.push((xt, yt))
      }
      
      // Create closed path for the violin
      if bottom-points.len() > 0 {
        // Combine bottom and top points to form a closed shape
        top-points = top-points.rev()
        let all-points = bottom-points + top-points
        
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
          let bottom-path = (std.curve.move(bottom-points.at(0)),)
          for pt in bottom-points.slice(1) {
            bottom-path.push(std.curve.line(pt))
          }
          place(std.curve(..bottom-path, stroke: style.stroke))
          
          let top-path = (std.curve.move(top-points.at(0)),)
          for pt in top-points.slice(1) {
            top-path.push(std.curve.line(pt))
          }
          place(std.curve(..top-path, stroke: style.stroke))
        }
      }
    }
    
    // Draw mean marker if requested
    if style.mean != none and "mean" in data {
      let (mean-x, _) = transform(data.mean, y)
      let (_, mean-y) = transform(0, y)
      
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

/// Computes and visualizes one or more horizontal violin plots from datasets. 
/// 
/// This is the horizontal version of @violin. A violin plot uses kernel 
/// density estimation to show the distribution of the data.
/// 
/// ```example
/// #lq.diagram(
///   lq.hviolin(
///     (1, 2, 3, 4, 5, 6, 7, 8, 9),
///     range(1, 20),
///     (1, 28, 25, 30),
///   )
/// )
/// ```
#let hviolin(

  /// One or more data sets to generate violin plots from. Each dataset should be
  /// an array of numerical values.
  /// -> array
  ..data,

  /// The $y$ coordinate(s) to draw the violin plots at. If set to `auto`, plots will 
  /// be created at integer positions starting with 1. 
  /// -> auto | int | float | array
  y: auto,

  /// The width of the violin plots in $y$ data coordinates. This can be a constant width
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
  
  if type(y) in (int, float, datetime) { y = (y,) }
  else if y == auto { y = range(1, num-violins + 1) }

  let datetime-axes = (:)
  if type(y.at(0, default: 0)) == datetime {
    y = time.to-seconds(..y)
    datetime-axes.y = true
  }

  assert(
    y.len() == num-violins, 
    message: "The number of y coordinates does not match the number of data arrays"
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
    
    let kde-result = komet.kde(
      dataset,
      bandwidth: bandwidth,
      num-points: num-points
    )
    all-values += kde-result.x
    
    let mean-value = dataset.fold(0.0, (acc, val) => acc + float(val)) / dataset.len()
    
    processed-data.push((
      kde: kde-result,
      mean: mean-value,
    ))
  }

  let xmax = calc.max(..all-values)
  let xmin = calc.min(..all-values)
  let ymin = y.at(0) - width.at(0)
  let ymax = y.at(-1) + width.at(-1)

  (
    y: y,
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
    plot: render-hviolin,
    xlimits: () => (xmin, xmax),
    ylimits: () => (ymin, ymax),
    datetime: datetime-axes,
    legend: true,
    clip: clip,
    z-index: z-index
  )
}
