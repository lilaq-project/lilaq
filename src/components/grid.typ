#import "../libs/elembic/lib.typ" as e


/// An axis grid for highlighting tick positions in the diagram area. The 
/// grid lines are determined from the ticks located by the tick locators
/// of the main $x$ and $y$ axes for vertical and horizontal grid lines, 
/// respectively. 
/// 
/// One way to set up the grid stroke is with a style rule. The stroke 
/// of the main ticks is controlled by `stroke`
/// 
/// ```example
/// #show: lq.set-grid(stroke: teal)
/// 
/// #lq.diagram(
/// 
/// )
/// ```
/// and the stroke of the subticks by `sub`:
/// ```example
/// #show: lq.set-grid(sub: .5pt + luma(90%))
/// 
/// #lq.diagram(
/// 
/// )
/// ```
/// 
/// Through the @diagram.grid parameter, the look of the grid can also be 
/// controlled directly for an individual diagram. 
/// ```example
/// #lq.diagram(
///   grid: (stroke: black, sub: .25pt)
/// )
/// ```
/// 
/// Aside from `#show: lq.set-grid(stroke: none)`, the grid can be turned off 
/// with the short-hand `grid: none`. 
/// ```example
/// #lq.diagram(
///   grid: none
/// )
/// ```
#let grid(

  /// A list of tick positions as absolute length coordinates within the 
  /// diagram frame. This is automatically filled by @diagram with the ticks 
  /// resulting from the axes' tick locators. 
  /// -> array
  ticks,

  /// A list of subtick positions as absolute length coordinates within the 
  /// diagram frame. This is automatically filled by @diagram with the ticks 
  /// resulting from the axes' tick locators. 
  /// -> array
  subticks,

  /// The axis kind: horizontal (`"x"`) or vertical (`"y"`). 
  /// -> "x" | "y"
  kind: "x",

  /// How to stroke grid lines. 
  /// -> none | stroke
  stroke: 0.5pt + luma(80%),

  /// How to stroke grid lines for subticks. If `auto`, the style is inherited
  /// from @grid.stroke. 
  /// -> auto | none | stroke
  sub: none,

  /// Determines the $z$ position of the grid in the order of rendered diagram
  /// objects. See @plot.z-index.  
  /// -> int | float
  z-index: 0,
  
) = {}


// A stroke type that can also be auto or none and that still
// folds correctly. During folding auto and none override an 
// existing stroke fully. 
#let auto-none-stroke = e.types.wrap(
  e.types.smart(e.types.option(stroke)),
  fold: old-fold => (outer, inner) => if inner in (none, auto) or outer in (none, auto) { inner } else { (e.types.native.stroke_.fold)(outer, inner) }
)

#let grid = e.element.declare(
  "grid",
  prefix: "lilaq",

  display: it => {

    let line

    if it.kind == "x" {
      line = (tick, stroke: it.stroke) => place(
        std.line(start: (tick, 0%), end: (tick, 100%), stroke: stroke)
      )
    } else if it.kind == "y" {
      line = (tick, stroke: it.stroke) => place(
        std.line(start: (0%, tick), end: (100%, tick), stroke: stroke)
      )
    }

    if it.stroke != none {
      it.ticks.map(line).join()
    }

    let sub-stroke = if it.sub == auto { it.stroke } else { it.sub }

    if sub-stroke != none {
      it.subticks.map(line.with(stroke: sub-stroke)).join()
    }
  },

  fields: (
    e.field("ticks", array, required: true),
    e.field("subticks", array, required: true),
    e.field("stroke", e.types.option(stroke), default: 0.5pt + luma(80%), ),
    e.field("sub", auto-none-stroke, default: none),
    e.field("z-index", float, default: 0),
    e.field("kind", str, default: "x"),
  ),
)