/// A tick on a diagram axis. 
/// TODO: Not used yet

#let tick-label(

  body

) = {}


/// A tick on a diagram axis. 
#let tick(
  
  /// Position of the tick in data coordinates. 
  /// -> float
  value, 

  /// Tick label. 
  /// -> any
  label: none,

  /// Stroke of the tick. If set to `auto`, the stroke is inherited the axis spine. 
  /// -> auto | stroke
  stroke: auto,

  /// Length of the tick outside the diagram. 
  /// -> length
  outset: 0pt,
  
  /// Length of the tick inside the diagram. 
  /// -> length
  inset: 4pt
  
) = (
  value: value,
  label: label,
  stroke: stroke,
  outset: outset,
  inset: inset,
)



#import "../process-styles.typ": twod-ify-alignment
#import "../libs/elembic/lib.typ" as e

#let tick = e.element.declare(
  "tick",
  prefix: "lilaq",

  display: it => {
    // return it.label
    let angle = 0deg
    if it.align in (top, bottom) {
      angle = 90deg
    }
    let length = it.inset + it.outset

    box(inset: (repr(it.align): it.pad + it.outset), {
      place(
        twod-ify-alignment(it.align), 
        pad(
          ..(repr(it.align): -it.pad - length),
          line(length: length, angle: angle)
        )
      )
      it.label
  })
  },

  labelable: false,

  fields: (
    e.field("value", float, required: true),
    e.field("label", e.types.any, default: none),
    e.field("kind", str, default: "x"),
    e.field("align", e.types.wrap(alignment, fold: none), default: right),
    e.field("stroke", e.types.smart(stroke), default: .7pt),
    e.field("pad", length, default: 0.5em),
    e.field("outset", length, default: 0pt),
    e.field("inset", length, default: 3pt),
  )
)


#tick(34, label: [34])
#tick(34, label: [34], align: left)
#tick(34, label: [34], align: top)
#tick(34, label: [34], align: bottom)

#tick(34, label: [34], inset: 2pt)
#tick(34, label: [34], align: left, inset: 2pt)
#tick(34, label: [34], align: top, inset: 2pt)
#tick(34, label: [34], align: bottom, inset: 2pt)