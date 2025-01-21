#import "../plot-utils.typ": merge-strokes, plot-lim, merge-fills
#import "../assertations.typ"
#import "../process-points.typ": filter-nan-points, stepify
#import "../utility.typ": if-auto
#import "../cycle.typ": mark, prepare-mark, prepare-path


#let get-errorbar-stroke(base-stroke) = {
  if base-stroke == auto { return stroke() }
  if base-stroke == none { return stroke() }
  return stroke()
  return stroke(thickness: base-stroke.thickness, paint: base-stroke.paint)
}


#let render-plot(plot, transform) = {
  let (points, runs) = filter-nan-points(plot.x.zip(plot.y), generate-runs: true)

  if "make-legend" in plot {
    runs = (((0, .5), (1, .5)),)
    points = ((0.5,.5),)
    if plot.yerr != none { plot.yerr = (.5,) }
    if plot.xerr != none { plot.xerr = (.25,) }
  }



  let line = merge-strokes(plot.style.stroke, plot.style.color)
  if line != none {
    show: prepare-path.with(
      stroke: line
    )

    for run in runs {
      if plot.style.step != none { run = stepify(run, step: plot.style.step )}
      place(path(..run.map(p => transform(..p))))
    }
  }

  

  let get-upper-lower(value, error) = {
    if type(error) in (float, int) { 
      return (value - error, value + error)
    }
    if type(error) == array { 
      assert.eq(error.len(), 2, message: "Individual errors need to be numbers or pairs of numbers, encountered array of length " + str(error.len()))
      return (value - error.at(0), value + error.at(1))
    }
    assert(false, "Invalid type \'" + str(type(err)) + "\' for error")
  }


  let errorbar-stroke = prepare-path.with(
    stroke: merge-strokes((dash: "solid"), plot.style.stroke, plot.style.color)
  )

  
  if plot.xerr != none {
    show: errorbar-stroke
    
    points.zip(plot.xerr).map((((x, y), xerr)) => {
      let (upper, lower) = get-upper-lower(x, xerr)
      place(path(transform(lower, y), transform(upper, y)))
      
    }).join()
  }
  
  if plot.yerr != none {
    show: errorbar-stroke
    
    points.zip(plot.yerr).map((((x, y), yerr)) => {
      let (upper, lower) = get-upper-lower(y, yerr)
      place(path(transform(x, lower), transform(x, upper)))
      
    }).join()
  }
  

  
  show: prepare-mark.with(
    func: plot.mark.mark, 
    color: merge-fills(plot.style.color),
    fill: plot.mark.fill,
    size: plot.mark.size
  )
  
  let marker = mark()
  let transformed-points = points.map(p => transform(..p))
  transformed-points.map(((x, y)) => place(dx: x, dy: y, marker)).join()

  

  // let errorbars = plot.yerr != none or plot.xerr != none
  // let errorbar-stroke = get-errorbar-stroke(plot.style.line)
  
  // let i = 0
  // for (x, y) in points {
  //   let p = transform(x, y)
  //   if errorbars {
        
  //     show: prepare-path.with(
  //       stroke: merge-strokes((dash: "solid", paint: red, thickness: .2pt), plot.style.line, plot.style.color)
  //     )
  //     if plot.xerr != none {
  //       let (upper, lower) = get-upper-lower(x, plot.xerr.at(i))
  //       place(path(transform(lower, y), transform(upper, y)))
  //     }
  //     if plot.yerr != none {
  //       let (upper, lower) = get-upper-lower(y, plot.yerr.at(i))
  //       place(path(transform(x, lower), transform(x, upper)))
  //     }
  //   }
  //   place(dx: p.at(0), dy: p.at(1), marker)

  //   i += 1
  // }
}


// #let plot-legend-handle(plot) = {
//   if plot.style.line != none {
//     place(horizon + center, path((0%, 0%), (0%, 100%), stroke: plot.style.line))
//   }
//   if plot.yerr != none {
//     let errorbar-stroke = get-errorbar-stroke(plot.style.line)
//     place(horizon + center, line(length: 100%, stroke: errorbar-stroke, angle: 90deg))
//   }
//   place(horizon + center, (plot.style.mark)(plot.style))
}


/// Standard plotting method for 2d data with lines and/or marks and optional  
/// error bars. Points where the $x$ or $y$ coordinate is `nan` are skipped. 
/// 
/// ```example
/// #let x = lq.linspace(0, 10)
/// 
/// #lq.diagram(
///   lq.plot(x, x.map(x => calc.sin(x)))
/// )
/// ```
/// 
/// By default, the line and mark style is determined by the current @diagram.cycle. 
/// However, they can be configured per plot with the options @plot.color, @plot.mark,
/// and @plot.stroke. 
/// 
/// This function is also intended for making plots with error bars. 
/// 
/// ```example
/// #lq.diagram(
///   lq.plot(
///     range(8), (3, 6, 2, 6, 5, 9, 0, 4),
///     yerr: (1, 1, .7, .8, .2, .6, .5, 1),
///     stroke: none, mark: "star",
///     mark-size: 6pt
///   )
/// )
/// ```
#let plot(
  
  /// An array of $x$ data coordinates. Data coordinates need to of type `int` or `float`. 
  /// -> array
  x, 
  
  /// An array of $y$ data coordinates. The number of $x$ and $y$ coordinates must match. 
  /// -> array
  y, 
  
  /// Optional errors/uncertainties for $x$ coordinates. The number of error values must
  /// match the number of coordinates. Each entry can either be a single value, describing 
  /// a symmetric uncertainty or a pair `(lower, uppper)` for asymmetric errorbars. 
  /// -> none | array
  xerr: none,
  
  /// Optional errors for $y$ coordinates. See @plot.xerr. 
  /// -> none | array
  yerr: none,
  
  /// Combined color for line and marks. See also the parameters @plot.stroke and 
  /// @plot.mark-fill which take precedence over `color`, if set. 
  /// -> auto | color
  color: auto,
  
  /// The line style to use for this plot (takes precedence over @plot.color). 
  /// -> auto | stroke
  stroke: auto, 
  
  /// The mark to use to mark data points. This may either be a mark (such as 
  /// `lq.mark.x`) or a registered mark string, see @mark. 
  /// -> auto | lq.mark | string
  mark: auto, 
  
  /// Size of the marks. For variable-size mark plots, use the plot type @scatter. 
  /// -> auto | length
  mark-size: auto,
  
  /// Color of the marks (takes precedence over @plot.color). 
  /// TODO: this parameter should eventually be removed. Instead one
  /// would be able to set mark color and stroke through
  /// ```
  /// #lq.diagram(
  ///  plot(..), // normal plot
  ///  {
  ///    set mark(fill: red, stroke: black)
  ///    plot(..)
  ///  }
  ///)
  /// ```
  /// This again reduces the API. `mark.size` however is common enough to deserve 
  /// its own parameter. 
  /// -> auto | color
  mark-color: auto,
  
  /// Step mode for plotting the lines. 
  /// - `none`: Consecutive data points are connected with a straight line. 
  /// - `start`: The interval $(x_(i-1), x_i]$ takes the value of $x_i$. 
  /// - `center`: The value switches half-way between consecutive $x$ positions. 
  /// - `end`: The interval $[x_i, x_(i+1))$ takes the value of $x_i$. 
  ///
  /// #details[
  ///   ```example
  ///   #import lilaq
  ///
  ///   #lq.diagram(
  ///     lq.plot(
  ///       range(8), (3,6,2,6,5,9,0,4),
  ///       step: center
  ///     )
  ///   )
  ///   ```
  /// ]
  /// -> none | start | end | center
  step: none,
  
  /// The legend label for this plot. If not given, the plot will not appear in the 
  /// legend. 
  /// -> any
  label: none,
  
  /// Whether to clip the plot to the data area. This is usually a good idea for plots 
  /// with lines but it does also clip part of marks that lie right on an axis. 
  /// -> boolean
  clip: true,
  
  /// Specifies the $z$ position of this plot in the order of rendered diagram objects. 
  /// This makes it also possible to render plots in front of the axes which have a 
  /// z-index of `2.1`.  
  /// -> int | float
  z-index: 2,
  
) = {
  if type(xerr) in (int, float) { xerr = (xerr,) * x.len() }
  if type(yerr) in (int, float) { yerr = (yerr,) * x.len() }
  assertations.assert-matching-data-dimensions(x, y, xerr: xerr, yerr: yerr, fn-name: "plot")
  assert(step in (none, start, end, center))
  (
    x: x,
    y: y,
    xerr: xerr,
    yerr: yerr,
    label: label,
    mark: (
      mark: mark,
      fill: mark-color,
      size: mark-size
    ),
    style: (
      stroke: stroke,
      color: color,
      step: step
    ),
    plot: render-plot,
    xlimits: () => plot-lim(x, err: xerr),
    ylimits: () => plot-lim(y, err: yerr),
    legend-handle: plot => none,
    new-legend: true,
    clip: clip,
    z-index: z-index
  )
}
