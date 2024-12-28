

/// A label for an axis. 
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

#let xlabel = label
#let ylabel = label.with(angle: -90deg)

#let label-show = it => {
  rotate(it.angle, it.body, reflow: true)
}

