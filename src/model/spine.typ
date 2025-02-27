


#import "../libs/elembic/lib.typ" as e
#import "@preview/tiptoe:0.2.0"


/// A tick on a diagram axis. A tick consists of a tick mark on the axis and
/// a tick label, usually a number denoting the coordinate value. 
#let spine(
  
  /// How to stroke the spine of the axis. 
  stroke: 0.7pt,

  tip: none,

  toe: none

) = {}




#let spine = e.element.declare(
  "spine",
  prefix: "lilaq",

  display: it => {
    if it.stroke == none { return }
    let line
    if it.kind == "x" {
      line = tiptoe.line.with(tip: it.tip, toe: it.toe)
    } else if it.kind == "y"{
      line = tiptoe.line.with(angle: 90deg, tip: it.toe, toe: it.tip)
    }
    line(length: 100%, stroke: it.stroke)
  },

  fields: (
    e.field("stroke", stroke, default: 0.7pt),
    e.field(
      "kind", 
      e.types.union(e.types.literal("x"), e.types.literal("y")), 
      default: "x"
    ),
    e.field("tip", e.types.option(function), default: none),
    e.field("toe", e.types.option(function), default: none),
  )
)
