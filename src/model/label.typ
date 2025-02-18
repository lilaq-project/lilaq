

/// A label for a diagram axis. 
#let label(
  /// Content to show in the label. 
  /// -> any
  body,

  /// Horizontal offset
  /// -> auto | length
  dx: auto,

  /// Vertical offset
  /// -> auto | length
  dy: auto,

  /// Padding between the axis (and its ticks and labels) and the label. 
  /// -> length
  pad: .5em,

  /// Angle at which the label is drawn. 
  /// -> angle
  angle: 0deg
  
) = {
  (
    body: body,
    dx: dx,
    dy: dy,
    pad: pad,
    angle: angle
  )
}



#import "../libs/elembic/lib.typ" as e

#let label = e.element.declare(
  "label",
  prefix: "lilaq",

  display: it => rotate(it.angle, it.body, reflow: true),

  fields: (
    e.field("body", content, required: true),
    e.field("dx", e.types.union(auto, length), default: auto),
    e.field("dy", e.types.union(auto, length), default: auto),
    e.field("pad", length, default: .5em),
    e.field("angle", angle, default: 0deg),
  )
)



#let xlabel = label
#let ylabel = label.with(angle: -90deg)
