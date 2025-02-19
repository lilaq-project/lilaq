#import "../logic/process-coordinates.typ": convert-vertex
#import "../logic/limits.typ": compute-primitive-limits


/// Draws a line onto the data area. 
/// ```example
/// #lq.diagram(
///   width: 3cm, height: 3cm,
///   lq.line((1, 2), (5, 4))
/// )
/// ```
/// The coordinates can also be given relative to the data area 
/// (`0%` means at the very left/top and `100%` at the very right/bottom)
/// ```example
/// #lq.diagram(
///   width: 3cm, height: 3cm,
///   lq.line((0%, 0%), (100%, 100%))
/// )
/// ```
/// or mixed between relative, absolute and data values. 
/// ```example
/// #lq.diagram(
///   width: 3cm, height: 3cm,
///   lq.line(
///     stroke: (paint: blue, dash: "dashed"),
///     (1, 100%), (4, 10pt)
///   )
/// )
/// ```
#let line(

  /// The start point of the line. Coordinates can be given as
  /// - data coordinates (`int` or `float`),
  /// - or absolute coordinates from the top left corner of the data area (`length`),
  /// - or in percent relative to the data area (`ratio`),
  /// - or a combination of the latter two (`relative`).  
  /// -> array
  start, 

  /// The end point of the line, see @line.start. 
  /// -> array
  end,

  /// How to stroke the line. 
  /// -> auto | stroke
  stroke: auto,
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Whether to clip the plot to the data area. See @plot.clip. 
  /// -> bool
  clip: true,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2,

) = {
  let vertices = (start, end)
  (
    plot: (plot, transform) => { 
      place(std.path(
        stroke: stroke,
        ..vertices.map(convert-vertex.with(transform: transform))
      ))
    },
    xlimits: compute-primitive-limits.with(vertices.map(x => x.at(0))),
    ylimits: compute-primitive-limits.with(vertices.map(x => x.at(1))),
    legend-handle: plot => std.line(start: (0pt, 100%), end: (100%, 0pt), stroke: stroke),
    label: label,
    clip: clip,
    z-index: z-index
  )
}
