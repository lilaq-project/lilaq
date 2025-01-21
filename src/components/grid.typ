#import "../libs/elembic/lib.typ" as e


/// An axis grid for highlighting tick positions in the diagram area. 
#let grid(

  /// A list of tick positions in length coordinates. 
  /// -> array
  ticks,

  /// A list of subtick positions in length coordinates. 
  /// -> array
  subticks,

  /// Axis kind. 
  /// -> "x" | "y"
  kind: "x",

  /// How to stroke grid lines
  /// -> none | stroke
  stroke: 0.5pt + luma(80%),

  /// How to stroke grid lines for subticks. If `auto`, the style is inherited from @grid.stroke. 
  /// -> auto | none | stroke
  sub: none,

  /// Determines the $z$ position of the grid in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 0,
  
) = {}

#let grid = e.element.declare(
  "grid",
  prefix: "lilaq",

  display: it => {
    let sub-stroke = if it.sub == auto { it.stroke } else { it.sub }

    if it.kind == "x" {

      if it.stroke != none {
        for tick in it.ticks {
          place(line(start: (tick, 0%), end: (tick, 100%), stroke: it.stroke))
        }
      }
      if sub-stroke != none {
        for tick in it.subticks {
          place(line(start: (tick, 0%), end: (tick, 100%), stroke: sub-stroke))
        }
      }
    } else if it.kind == "y" {

      if it.stroke != none {
        for tick in it.ticks {
          place(line(start: (0%, tick), end: (100%, tick), stroke: it.stroke))
        }
      }
      if sub-stroke != none {
        for tick in it.subticks {
          place(line(start: (0%, tick), end: (100%, tick), stroke: sub-stroke))
        }
      }
    }
  },

  fields: (
    e.field("ticks", array, required: true),
    e.field("subticks", array, required: true),
    e.field("stroke", e.types.option(stroke), default: 0.5pt + luma(80%), ),
    e.field("sub", e.types.union(none, auto, stroke), default: none),
    e.field("z-index", float, default: 0),
    e.field("kind", str, default: "x"),
  ),
)
