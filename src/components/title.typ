
/// A title for a `lq.diagram`. 
#let title(
  /// Content to show in the title. 
  /// -> any
  body,

  /// Position of the title
  pos: top,

  /// Horizontal offset
  /// -> auto | length
  dx: auto,

  /// Vertical offset
  /// -> auto | length
  dy: auto,

  /// Padding between the diagram and the title. 
  /// -> length
  pad: .5em,
  
) = {
  assert(pos in (top, bottom, left, right), message: "`pos` needs to be one of \"top\", \"left\", \"bottom\", and \"right\"")
  (
    body: body,
    pos: pos,
    dx: dx,
    dy: dy,
    pad: pad
  )
}

#let title-show = it => {
  it.body
}


#import "../libs/elembic/lib.typ" as e



#let title = e.element.declare(
  "title",
  prefix: "lilaq",

  // Default show rule receives the constructed element.
  display: it => it.body,

  fields: (
    // Specify field name, type, brief description and default.
    // This allows us to override the color if desired.
    e.field("body", content, required: true),
    e.field("pos", alignment, default: top),
    e.field("dx", e.types.union(auto, length), default: auto),
    e.field("dy", e.types.union(auto, length), default: auto),
    e.field("pad", length, default: .5em),
  )
)


