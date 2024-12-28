
#import "../plot-utils.typ": merge-strokes
#import "../math.typ": minmax




#let render-vlines(plot, transform) = {
  let min = plot.min
  let max = plot.max
  if min == auto { min = 100% }
  else {
    (_, min) = transform(1, min)
    
  }
  if max == auto { max = 0% }
  else {
    (_, max) = transform(1, max)
    
  }
  for x in plot.x {
    let (xx, _) = transform(x, 1)
    place(line(start: (xx, min), end: (xx, max), stroke: plot.style.line))
  }
}



/// Draws a set of vertical lines into the diagram. 
#let vlines(

  /// The $x$ coordinate(s) of one or more vertical lines to draw. 
  /// -> int | float | array
  x, 

  /// The beginning of the line as $y$ coordinate. If set to `auto`, the line will 
  /// always start at the bottom of the diagram. 
  /// -> auto | int | float
  min: auto,
  
  /// The end of the line as $y$ coordinate. If set to `auto`, the line will 
  /// always end at the top of the diagram. 
  /// -> auto | int | float
  max: auto,

  /// How to stroke the lines
  /// -> stroke
  line: blue,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2,
  
  
) = {
  assert(type(x) in (array, int, float))
  line = merge-strokes(line)
  if type(x) in (int, float) {
    x = (x,)
  }
  let ylimits = none
  if min != auto {
    ylimits = (min, min)
  }
  if max != auto {
    ylimits = (if min == auto { max } else { min }, max)
  }
  (
    x: x,
    min: min, 
    max: max,
    label: label,
    style: (
      line: line,
    ),
    plot: render-vlines,
    xlimits: () => minmax(x),
    ylimits: () => ylimits,
    legend-handle: plot => {
      std.line(length: 100%, stroke: line)
    },
    z-index: z-index
  )
}
