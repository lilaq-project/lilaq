
/// A title for a diagram. 
#let title(
  /// Content to show in the title. 
  /// -> any
  body,

  /// Position of the title
  pos: top,

  /// Horizontal offset
  /// -> length
  dx: 0pt,

  /// Vertical offset
  /// -> length
  dy: 0pt,

  /// Padding between the diagram and the title. 
  /// -> length
  pad: 0.5em,
  
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

  display: it => it.body,

  fields: (
    e.field("body", content, required: true),
    e.field("pos", alignment, default: top),
    e.field("dx", length, default: 0pt),
    e.field("dy", length, default: 0pt),
    e.field("pad", length, default: 0.5em),
  )
)


