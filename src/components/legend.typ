#import "../process-styles.typ": twod-ify-alignment
#import "../bounds.typ": place-with-bounds
#import "../libs/elembic/lib.typ" as e

/// A diagram legend showing labels for all labeled plots. 
#let legend(

  /// The items to place in the legend. These items are tuples of a 
  /// plot preview image and the corresponding label. The children are 
  /// filled automatically by @diagram. 
  /// -> array
  children,

  /// How to fill the background of the legend. 
  /// -> none | color | tiling
  fill: white.transparentize(20%),

  /// Determines the padding of the entire legend within its box. 
  /// -> relative
  inset: relative, default: .3em,

  /// How to stroke the outer border of the legend. 
  /// -> none | stroke 
  stroke: 0.5pt + gray,

  /// The radius of the outer border of the legend. 
  /// -> relative | dictionary
  radius: 1.5pt,

  /// Where to place the legend in the diagram. This can be an alignment
  /// or a position `(x, y)` where `x` and `y` are relative lengths, i.e., 
  /// they can be
  /// - lengths like `20pt` or `2em`,
  /// - ratios like `50%` (measuring in the diagram area),
  /// - or a combination thereof. 
  /// -> alignment | array
  pos: top + right,

  /// In the case that @legend.pos is an `alignment`, `pad` determines how much to pad the legend from the 
  /// -> length
  pad: 2pt, 

  // 
  /// -> length
  dx: 0pt,

  /// -> length
  dy: 0pt,

  /// -> int | float
  z-index: 6,

) = {}


#let legend = e.element.declare(
  "legend",
  prefix: "lilaq",

  display: it => box(
    stroke: it.stroke,
    inset: it.inset,
    fill: it.fill,
    radius: it.radius,
    table(..it.children.join())
  ),

  fields: (
    e.field("children", e.types.array(e.types.any), required: true),
    e.field("fill", e.types.option(e.types.paint), default: white.transparentize(20%)),
    e.field("inset", relative, default: .3em),
    e.field("stroke", e.types.option(stroke), default: 0.5pt + gray),
    e.field("radius", e.types.union(relative, dictionary), default: 1.5pt),
    
    e.field("pos", e.types.union(alignment, array), default: top + right),
    e.field("pad", length, default: 2pt),
    e.field("dx", length, default: 0pt),
    e.field("dy", length, default: 0pt),
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


#let place-legend-with-bounds(

  /// -> lq.legend | true | dictionary
  my-legend, 

  /// -> array(array)
  legend-entries,

  e-get

) = {
  let nested-get-field(element, object, field) = {
    e.fields(object).at(field, default: e-get(element).at(field))
  }

  if my-legend == true { my-legend = (:)}
  my-legend = legend(..legend-entries, ..my-legend)

  let pos = nested-get-field(legend, my-legend, "pos")
  let dx = nested-get-field(legend, my-legend, "dx")
  let dy = nested-get-field(legend, my-legend, "dy")
  let pad = nested-get-field(legend, my-legend, "pad")

  let alignment = top + left

  if type(pos) == std.alignment {
    alignment = pos
  } else if type(pos) == array {
    assert.eq(pos.len(), 2, message: "`legend.pos` needs to be a pair of coordinates, got " + repr(pos))
    dx += pos.at(0)
    dy += pos.at(1)
  }
  
  place-with-bounds(
    alignment: alignment, 
    content-alignment: "inside", 
    dx: dx, dy: dy, pad: pad,
    {
      set table(columns: 2, stroke: none, inset: 2pt, align: horizon + left)
      my-legend
    }
  )
}