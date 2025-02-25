#import "../assertations.typ"
#import "../logic/limits.typ": compute-primitive-limits
#import "../logic/process-coordinates.typ": convert-bezier-curve, transform-point


/// Draws a path into the data area. Each vertex may be given as data coordinates, 
/// as percentage relative to the data area or in absolute lengths (see @rect). 
///
/// ```example
/// #lq.diagram(
///   height: 3.8cm,
///   width: 4cm, 
///   lq.path(
///     ((0, 1), (0, -1)),
///     ((.5, 1), (0, 1)),
///     ((0,-1), (0, 1), (0, 1)),
///     ((-.5, 1), (0, -1)),
///     ((0, 1), (0, 1)),
///     stroke: red + 2pt
///   )
/// )
/// ```
/// 
#let path(

  /// Vertices and curve elements. See the Typst built-in `path` function. 
  /// -> array
  ..vertices,

  /// How to fill the path.  
  /// -> none | color | gradient | tiling
  fill: none,

  /// How to stroke the path.
  /// -> auto | none | stroke
  stroke: auto,

  /// Whether to close the path. 
  /// -> bool
  closed: false,

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
  assertations.assert-no-named(vertices, fn: "path")

  let sub(p, q) = (p.at(0) - q.at(0), p.at(1) - q.at(1))
  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))

  vertices = vertices.pos()
  let all-points = vertices.enumerate().map(((i, v)) => {
    if type(v.at(0)) != array { return (v,) }
    if v.len() == 3 { 
      return (v.at(0),) + v.slice(1).map(c => {
         if not c.map(type).all(x => x in (int, float)) { return v.at(0) }
        add(v.at(0), c)
      }) 
    } 
    let vs = (v.at(0),)
    if i != 0 and v.at(1).map(type).all(x => x in (int, float)){
      vs.push(add(v.at(0), v.at(1)))
    }
    if i != vertices.len() - 1 {
      // vs.push(sub(v.at(0), v.at(1)))
    }
    return vs
  }).join()
  // vertices = all-points  
  // let all-points = vertices
  (
    vertices: vertices,
    plot: (plot, transform) => { 
      let new-vertices = vertices.map(v => {
        if type(v.at(0)) != array { return transform-point(..v, transform) }
        return convert-bezier-curve(v, transform)
        let p = transform-point(..v.at(0), transform)
        let cs = v.slice(1).map(c => {
          let cabs = add(v.at(0), c)
          let cabs = c
          sub(transform-point(..cabs, transform), p)
        })
        (p,) + cs
      })
      place(std.path(
        fill: fill, stroke: stroke, closed: closed,
        // ..vertices.map(((x, y)) => convert-point(x, y, transform))
        ..new-vertices
      ))
    },
    xlimits: compute-primitive-limits.with(all-points.map(x => x.at(0))),
    ylimits: compute-primitive-limits.with(all-points.map(x => x.at(1))),
    legend-handle: plot => std.rect(
      width: 100%, height: 100%, 
      fill: fill, stroke: stroke
    ),
    label: label,
    clip: clip,
    z-index: z-index
  )
}
