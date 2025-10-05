#import "bar.typ": *


/// Creates a horizontal bar plot from the given bar positions and lengths. 
/// 
/// ```example
/// #lq.diagram(
///   yaxis: (subticks: none),
///   lq.hbar(
///     (1, 2, 3, 2, 5, 3), 
///     (1, 2, 3, 4, 5, 6), 
///   )
/// )
/// ```
/// 
/// Also see @bar. 
#let hbar(
  
  /// An array of $x$ coordinates specifying the bar lengths. 
  /// -> array
  x, 
  
  /// An array of $y$ coordinates specifying the bar positions. The number of 
  /// $x$ and $y$ coordinates must match. 
  /// -> array
  y, 

  /// How to fill the bars. This can be a single value applied to all bars or
  /// an array with the same length as the coordinate arrays.
  /// -> none | color | gradient | tiling | array
  fill: auto,

  /// How to stroke the bars. All values allowed by the built-in `rect`
  /// function are also allowed here, see 
  /// [`std.rect#stroke`](https://typst.app/docs/reference/visualize/rect/#parameters-stroke). 
  /// In particular, note that by passing a dictionary, the individual sides
  ///  of the bars can be stroked independently. 
  /// -> auto | none | color | length | stroke | gradient | tiling | dictionary
  stroke: none,

  /// Alignment of the bars at the $y$ values. 
  /// #details[
  ///   Demonstration of the different alignment modes. 
  ///   ```example
  ///   #lq.diagram(
  ///     yaxis: (subticks: none),
  ///     lq.hbar(
  ///       (1,2,3,4,5), (1,2,3,4,5), 
  ///       width: 0.2, fill: red, 
  ///       align: top, label: "top"
  ///     ),
  ///     lq.hbar(
  ///       (5,4,3,2,1), (1,2,3,4,5), 
  ///       width: 0.2, fill: blue, 
  ///       align: bottom, label: "bottom"
  ///     ),
  ///     lq.hbar(
  ///       (2.5,) * 5, (1,2,3,4,5), 
  ///       width: 0.2, fill: rgb("#AAEEAA99"),
  ///       align: center, label: "center"
  ///     ),
  ///   )
  ///   ```
  /// ]
  /// -> top | center | bottom
  align: center,

  /// Width of the bars. This can be a 
  /// - `ratio` (e.g., `80%`) specifying the width relative to the minimum
  ///   distance between two adjacent bars, (if there is only one bar, the
  ///   width is set to the given ratio of 1 data unit), 
  /// - a `float` or `int` specifying the width directly in data
  ///   coordinates. In this case, the width can be set either to a constant
  ///   for all bars or per-bar by passing an array with the same length as 
  ///   the coordinate arrays,
  /// - or a `duration` specifying the width in terms of time units when the 
  ///   coordinates @hbar.y are of type `datetime`. Again, this can be a constant
  ///   or an array.
  /// 
  /// #details[
  ///   Example for a bar plot with varying bar widths.
  ///   ```example
  ///   #lq.diagram(
  ///     lq.hbar(
  ///       (1, 2, 3, 2, 5), 
  ///       (1, 2, 3, 4, 5), 
  ///       width: (1, 0.5, 1, 0.5, 1), 
  ///       fill: orange, 
  ///     )
  ///   )
  ///   ```
  /// ]
  /// -> ratio | int | float | duration | array
  width: 80%,

  /// An offset to apply to all $y$ coordinates. This is equivalent to replacing
  /// the array passed to @bar.y with `y.map(y => y + offset)`. Using an offset
  /// can be useful to avoid overlaps when plotting multiple bar plots into one
  /// diagram. When @hbar.y is of type `datetime`, the offset can also be given
  /// as a `duration`.
  /// 
  /// The offset can also be configured per-bar by passing an array with the 
  /// same length as the coordinate arrays.
  /// -> int | float | duration | array
  offset: 0,


  /// Defines the $x$ coordinate of the baseline of the bars. This can either  
  /// be a constant value applied to all bars or it can be set per-bar by
  /// passing an array with the same length as the coordinate arrays. 
  /// #details[
  ///   Bar plot with varying base. 
  ///   ```example
  ///   #lq.diagram(
  ///     yaxis: (subticks: none),
  ///     lq.hbar(
  ///       (1, 2, 3, 0, 5), 
  ///       (1, 2, 3, 4, 5), 
  ///       base: (0, 1, 2, -1, 0), 
  ///       fill: white, 
  ///       stroke: 0.7pt
  ///     )
  ///   )
  ///   ```
  /// ]
  /// -> int | float | array
  base: 0,
  
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
  let datetime-axes = (:)
  if type(x.at(0, default: 0)) == datetime {
    x = time.to-seconds(..x)
    datetime-axes.x = true
  }
  if type(y.at(0, default: 0)) == datetime {
    y = time.to-seconds(..y)
    datetime-axes.y = true
  }

  assertations.assert-matching-data-dimensions(
    x, y, width: width, base: base, offset: offset, fill: fill,
    fn-name: "hbar"
  ) 

  
  if type(width) == ratio {
    if y.len() >= 2 {
      width = width / 100% * calc.min(..y.windows(2).map(((a, b)) => calc.abs(b - a)))
    } else {
      width = width / 100%
    }
  } else if type(width) == duration {
    width = width.seconds()
  } else if type(width) == array and type(width.at(0, default: 0)) == duration {
    width = width.map(duration.seconds)
  }
 
  
  if offset != 0 {
    if type(offset) != array {
      offset = (offset,) * y.len()
    }
    if type(offset.at(0, default: 0)) == duration {
      offset = offset.map(duration.seconds)
    }
    y = y.zip(offset).map(array.sum)
  }
  
  if type(base) != array {
    base = (base,)
  }
  
  let offset-coeff = match(
    align,
    top, 0,
    center, -0.5, 
    bottom, -1
  )

  let simple-lims() = vec.add(
    minmax(y), 
    (offset-coeff*width, (1 + offset-coeff) * width)
  )
  
  let ylim = match-type(
    width,
    integer: simple-lims,
    float: simple-lims,
    array: () => (
      calc.min(..y.zip(width).map(((y, w)) => y + offset-coeff * w)),
      calc.max(..y.zip(width).map(((y, w)) => y + (1 + offset-coeff) * w)),
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
    plot: render-bar.with(orientation: "horizontal"),
    xlimits: () => bar-lim(x, base),
    ylimits: () => ylim,
    datetime: datetime-axes,
    legend: true,
    ignores-cycle: false,
    clip: clip,
    z-index: z-index
  )
}
