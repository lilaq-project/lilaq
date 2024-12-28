#import "../assertations.typ"
#import "../plot-utils.typ": merge-strokes, merge-fills
#import "../process-points.typ": filter-nan-points, stepify
#import "../math.typ": minmax

#let render-fill-between(plot, transform) = {
  let y2 = if plot.y2 == none { (0,)*plot.x.len() } else { plot.y2 }
  
  let (points, runs) = filter-nan-points(plot.x.zip(plot.y1, y2), generate-runs: true)
  
  for run in runs {
    let there = run.map(x => x.slice(0,2))
    let back = run.map(x => (x.at(0), x.at(2)))
    if plot.style.step != none {
      there = stepify(there, step: plot.style.step)
      back = stepify(back, step: plot.style.step)
    }
    place(path(
      fill: plot.style.fill, 
      stroke: plot.style.stroke,
      closed: true, 
      ..((there + back.rev()).map(p => transform(..p))))
    )
  }
}


/// Fills the area between two graphs or the area between one graph and $x$-axis. 
#let fill-between(

  /// An array of $x$ data coordinates. Data coordinates need to of type `int` or `float`. 
  /// -> array
  x, 

  
  /// An array of $y$ data coordinates. The number of $x$ and $y$ coordinates must match. 
  /// -> array
  y1, 

  
  /// An second array of $y$ data coordinates. If this is `none`, the area between the coordinates `y1` and the $x$-axis is filled. 
  /// -> none | array
  y2: none,

  /// How to stroke the area. 
  /// -> none | 
  stroke: none,

  /// How to fill the area. 
  /// -> none | color | gradient | pattern
  fill: blue,
  
  /// Step mode for plotting the lines. See @plot.step. 
  /// -> none | start | end | center
  step: none,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2,
  
) = {
  
  assertations.assert-matching-data-dimensions(x, x, y1: y1, y2: y2, fn-name: "fill-between")
  
  (
    x: x,
    y1: y1,
    y2: y2,
    label: label,
    style: (
      fill: fill,
      stroke: stroke,
      step: step,
    ),
    plot: render-fill-between,
    xlimits: () => minmax(x),
    ylimits: () => minmax(y1 + y2 + if y2 == none {(0,)}),
    legend-handle: plot => box(width: 100%, height: 100%, fill: plot.style.fill),
    z-index: z-index
  )
}
