#import "../process-styles.typ": twod-ify-alignment
#import "../libs/elembic/lib.typ" as e

#let legend = e.element.declare(
  "legend",
  prefix: "lilaq",

  display: it => {

    let pos = twod-ify-alignment(it.pos)
    
    let dx = it.dx
    let dy = it.dy
    
    if dx == auto {
      if pos.x == left { dx = 2pt }
      else if pos.x == right { dx = -2pt }
      else { dx = 0pt }
    }
    if dy == auto {
      if pos.y == top { dy = 2pt }
      else if pos.y == bottom { dy = -2pt }
      else { dy = 0pt }
    }
    
    place(pos, dx: dx, dy: dy, 
      box(
        stroke: it.stroke,
        inset: it.inset,
        fill: it.fill,
        radius: it.radius,
        table(..it.children.join())
      )
    )
  },

  fields: (
    e.field("children", e.types.array(e.types.any), required: true),
    e.field("fill", e.types.union(e.types.paint, none), default: white.transparentize(20%)),
    e.field("inset", relative, default: .3em),
    e.field("stroke", e.types.union(stroke, none), default: 0.5pt + gray),
    e.field("radius", e.types.union(relative, dictionary), default: 1.5pt),
    
    e.field("pos", alignment, default: top + right),
    e.field("dx", e.types.union(auto, length), default: auto),
    e.field("dy", e.types.union(auto, length), default: auto),
    e.field("z-index", float, default: 6),
  ),
  parse-args: (default-parser, fields: none, typecheck: none) => (args, include-required: false) => {
    let args = if include-required {
      let values = args.pos()
      arguments(values, ..args.named())
    } else if args.pos() == () {
      args
    } else {
      assert(false, message: "element 'legend': unexpected positional arguments\n  hint: these can only be passed to the constructor")
    }

    default-parser(args, include-required: include-required)
  },
)

