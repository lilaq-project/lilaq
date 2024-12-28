#import "../plot-utils.typ": merge-strokes
#import "../math.typ": minmax


#let render-hlines(plot, transform) = {
  let min = plot.min
  let max = plot.max
  if min == auto { min = 0% }
  else {
    (min, _) = transform(min, 1)
    
  }
  if max == auto { max = 100% }
  else {
    (max, _) = transform(max, 1)
    
  }
  for y in plot.y {
    let (_, yy) = transform(1, y)
    place(line(start: (min, yy), end: (max, yy), stroke: plot.style.line))
  }
}



/// Draws a set of horizontal lines into the diagram. 
#let hlines(

  /// The $y$ coordinate(s) of one or more horizontal lines to draw. 
  /// -> int | float | array
  y, 

  /// The beginning of the line as an $x$ coordinate. If set to `auto`, the line will 
  /// always start at the left edge of the diagram. 
  /// -> auto | int | float
  min: auto,
  
  /// The end of the line as an $x$ coordinate. If set to `auto`, the line will 
  /// always end at the right edge of the diagram. 
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
  assert(type(y) in (array, int, float))
  line = merge-strokes(line)
  if type(y) in (int, float) {
    y = (y,)
  }
  let xlimits = none
  if min != auto {
    xlimits = (min, min)
  }
  if max != auto {
    xlimits = (if min == auto { max } else { min }, max)
  }
  (
    y: y,
    label: label,
    min: min, 
    max: max,
    style: (
      line: line,
    ),
    plot: render-hlines,
    xlimits: () => xlimits,
    ylimits: () => minmax(y),
    legend-handle: plot => {
      std.line(length: 100%, stroke: line)
    },
    z-index: z-index
  )
}

