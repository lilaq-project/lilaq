#import "../process-styles.typ": twod-ify-alignment, update-stroke, ink, paper
#import "../bounds.typ": place-with-bounds
#import "../assertations.typ"
#import "@preview/elembic:1.1.1" as e

/// A diagram legend listing all labeled plots. 
/// 
/// ```example
/// #lq.diagram(
///   legend: (position: top + left),
/// 
///   lq.plot((1,2,3), (1,2,3), label: [Data A]),
///   lq.plot((1,2,3), (2,3,4), label: [Data B]),
/// )
/// ```
/// 
/// Also refer to the 
/// #link("tutorials/legend")[legend tutorial] for more details. 
#let legend(

  /// The items to place in the legend. This field is 
  /// filled automatically by @diagram. 
  /// -> array
  ..children,

  /// How to fill the background of the legend. With `auto`, the legend takes
  /// the page color at 80% opacity, or white when the page has no fill.
  /// -> auto | none | color | gradient | tiling
  fill: auto,

  /// Determines the padding of the entire legend within its box. 
  /// -> relative
  inset: 0.3em,

  /// How to stroke the outer border of the legend. A stroke without a paint
  /// takes the text color mixed a third into the page color, which with black
  /// text on white paper is `gray`.
  /// -> none | stroke 
  stroke: 0.5pt,

  /// The radius of the outer border of the legend. 
  /// -> relative | dictionary
  radius: 1.5pt,

  /// Where to place the legend in the diagram. This can be an alignment
  /// or a position `(x, y)` where `x` and `y` are relative lengths, i.e., 
  /// they can be
  /// - lengths like `20pt` or `2em`,
  /// - ratios like `50%` (measuring in the data area),
  /// - or a combination thereof. 
  /// 
  /// To place the legend outside the diagram, say to the right, use a 
  /// combination of `position: left + horizon` and `dx: 100%`. Positioning 
  /// of the legend is treated more in-depth in the
  /// #link("tutorials/legend#positioning")[legend tutorial].
  /// -> alignment | array
  position: top + right,

  /// In the case that @legend.position is an `alignment`, `pad` determines 
  /// how much to pad the legend from the outer edge of the data area 
  /// of the diagram. 
  /// -> length
  pad: 2pt, 

  /// The number of columns in the legend. The default is 1, which means that
  /// the legend entries are stacked vertically. With 2, the entries are
  /// arranged in two columns etc.
  /// -> int
  columns: 1,

  /// The ordering of the legend entries. With `ltr`, the entries are arranged
  /// left-to-right, with `ttb` they are arranged top-to-bottom.
  /// -> ltr | ttb
  ordering: ttb,

  /// The horizontal displacement of the legend from the position specified 
  /// through @legend.position. 
  /// -> relative
  dx: 0pt,

  /// The vertical displacement of the legend from the position specified 
  /// through @legend.position. 
  /// -> relative
  dy: 0pt,

  /// Specifies the $z$ position of the legend in the order of rendered
  /// diagram objects. 
  /// -> int | float
  z-index: 25,

) = {}

#let legend = e.element.declare(
  "legend",
  prefix: "lilaq",

  display: it => {
    let children = it.children
    assert(
      it.ordering in (ltr, ttb),
      message: "legend.ordering has to be ltr or ttb, got " + repr(it.ordering)
    )
    if it.ordering == ttb {
      let rows = calc.ceil(children.len() / 2 / it.columns)
      children += (none,) * (2 * rows * it.columns - children.len())
      children = array.zip(..children.chunks(2).chunks(rows)).join().join()
    }
    box(
      stroke: update-stroke(ink(mix: 100% / 3), it.stroke),
      inset: it.inset,
      fill: if it.fill == auto { paper().transparentize(20%) } else { it.fill },
      radius: it.radius,
      grid(..children, columns: it.columns * 2)
    )
  },

  fields: (
    e.field("children", e.types.array(e.types.any), required: true),
    e.field("fill", e.types.smart(e.types.option(e.types.paint)), default: auto),
    e.field("inset", relative, default: 0.3em),
    e.field("stroke", e.types.option(stroke), default: 0.5pt),
    e.field("radius", e.types.union(relative, dictionary), default: 1.5pt),
    
    e.field("position", e.types.union(alignment, array), default: top + right),
    e.field("pad", length, default: 2pt),
    e.field("columns", int, default: 1),
    e.field("ordering", direction, default: ttb),
    e.field("dx", relative, default: 0pt),
    e.field("dy", relative, default: 0pt),
    e.field("z-index", float, default: 6),
  ),

  parse-args: (default-parser, fields: none, typecheck: none) => (args, include-required: false) => {
    let args = if include-required {
      let values = args.pos()
      arguments(values, ..args.named())
    } else if args.pos() == () {
      args
    } else {
      return(false, "element 'legend': unexpected positional arguments\n  hint: these can only be passed to the constructor")
    }

    default-parser(args, include-required: include-required)
  },
)


#let _place-legend-with-bounds(

  /// -> none | dictionary | legend
  my-legend, 

  /// -> array(array)
  legend-entries,

  e-get

) = {
  let get-settable-field(element, object, field) = {
    e.fields(object).at(field, default: e-get(element).at(field))
  }

  if e.eid(my-legend) != e.eid(legend) {
    my-legend = legend(..legend-entries.join(), ..my-legend)
  }

  let pos = get-settable-field(legend, my-legend, "position")
  let dx = get-settable-field(legend, my-legend, "dx")
  let dy = get-settable-field(legend, my-legend, "dy")
  let pad = get-settable-field(legend, my-legend, "pad")

  let alignment = top + left
  let content-alignment = "inside"

  if type(pos) == std.alignment {
    alignment = pos
  } else if type(pos) == array {
    assert.eq(pos.len(), 2, message: "`legend.position` needs to be a pair of coordinates, got " + repr(pos))
    dx += pos.at(0)
    dy += pos.at(1)
    pad = 0pt
  } 

  place-with-bounds(
    alignment: alignment, 
    content-alignment: content-alignment, 
    dx: dx, dy: dy, pad: pad,
    wrap-in-box: true,
    {
      set grid(
        stroke: none, 
        inset: 2em / 11, 
        align: horizon + start
      )
      set grid.cell(breakable: false)
      my-legend
    }
  )
}
