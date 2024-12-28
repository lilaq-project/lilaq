
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