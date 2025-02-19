#import "../logic/scale.typ" as lqscale
#import "../utility.typ": place-in-out, match, match-type, if-auto
#import "../algorithm/ticking.typ"
#import "../bounds.typ": *
#import "../assertations.typ"
#import "../model/label.typ": xlabel, ylabel, label as lq-label
#import "../process-styles.typ": update-stroke
#import "../libs/elembic/lib.typ" as e
#import "@preview/zero:0.3.2"


#import "tick.typ": tick as tick-constructor


/// An axis for a diagram. Visually, an axis consists of a _spine_ along the axis direction, a collection of ticks/subticks and an axis label. 
#let axis(
  /// Sets the scale of the axis. This may be a `lq.scale` object or the name of one of the built-in scales `"linear"`, `"log"`, `"symlog"`.
  /// -> lq.scale | str 
  scale: "linear", 

  /// Data limits of the axis. Expects `auto` or a tuple `(min, max)` where `min` and `max` may be `auto`. The minimum may be larger than the maximum. 
  /// -> auto | array
  lim: auto,

  /// Label for the axis. Use a `lq.label` object for more options. 
  /// -> content | lq.label
  label: none,

  /// The kind of the axis. 
  /// -> "x" | "y"
  kind: "x", 

  /// -> float | alignment
  position: auto, 

  /// -> stroke
  stroke: .7pt,

  /// auto | bool
  mirror: auto,

  /// Specifies conversions between the data and the ticks. This can be used to
  /// configure a secondary axis to display the same data in a different unit, e.g., the main axis displays the velocity of a particle while the secondary axis displays the associated energy. In this case, one would pick `functions: (x => m*x*x, y => calc.sqrt(y/m))` with some constant `m`. Note that the first function computes the "forward" direction while the second function computes the "backward" direction. The user needs to ensure that the two functions are really inverses of each other. 
  /// This defaults to the identity. 
  /// auto | array
  functions: auto,

  /// The tick locator for the (major) ticks. 
  locate-ticks: auto,
  
  /// The formatter for the (major) ticks. 
  format-ticks: auto,
  
  /// The tick locator for the subticks. 
  locate-subticks: auto,
  
  /// The formatter for the subticks. 
  format-subticks: none,

  /// An array of extra ticks to display. The ticks can be positions given as `float` or `lq.tick` objects. 
  /// TODO: not implemented yet
  /// -> array
  extra-ticks: none, 

  /// The formatter for the extra ticks. 
  format-extra-ticks: none,

  /// Arguments to pass to the tick locator. 
  /// -> dictionary
  tick-args: (:),

  /// Arguments to pass to the subtick locator. 
  /// -> dictionary
  subtick-args: (:),

  /// Instead of using the tick locator, specifies the tick locations explicitly and optionally the tick labels. This can be an array with just the tick location or tuples of tick location and label, or a dictionary with the keys `ticks` and `labels`, containing arrays of equal length. When `ticks` is `none`, no ticks are displayed. If it is `auto`, the `tick-locator` is used. 
  /// -> auto | array | dictionary | none
  ticks: auto, 

  /// Instead of using the tick locator, specifies the tick positions explicitly and optionally the tick labels.
  /// -> auto | array | dictionary | none
  subticks: auto,

  /// Passes the parameter `tick-distance` to the tick locator. The linear tick locator respects this setting and sets the distance between consecutive ticks accordingly. If `tick-args` already contains an entry `tick-distance`, it takes precedence. 
  /// -> auto | float
  tick-distance: auto, 

  /// Offset for all ticks on this axis. The offset is subtracted from all ticks and shown at the end of the axis (if it is not 0). An offset can be used to avoid overly long tick labels and to focus on the relative distance between data points. 
  /// -> auto | float
  offset: auto,

  /// Exponent for all ticks on this axis. All ticks are divided by $10^"exponent"$ and the $10^"exponent"$ is shown at the end of the axis (if the exponent is not 0). This setting can be used to avoid overly long tick labels. 
  /// -> auto | float
  exponent: auto,

  /// Threshold for automatic exponents. 
  /// -> int
  auto-exponent-threshold: 3,

  /// If set to `true`, the entire axis is hidden. 
  /// -> bool
  hidden: false,

  /// Plot objects to associate with this axis. This only applies when this is a secondary axis. Automatic limits are then computed according to this axis and transformations of the data coordinates linked to the scaling of this axis. 
  /// -> any
  ..plots
  
) = {
  assertations.assert-no-named(plots)
  plots = plots.pos()
  if "tick-distance" not in tick-args {
    tick-args.tick-distance = tick-distance
  }
  if type(scale) == str {
    assert(scale in lqscale.scales, message: "Unknown scale " + scale)
    scale = lqscale.scales.at(scale)
  }
  assert(kind in ("x", "y"), message: "The `kind` of an axis can only be `x` or `y`")
  let translate = (0pt, 0pt)
  if position == auto {
    if kind == "x" { position = bottom }
    else if kind == "y" { position = left }
  } else if type(position) in (int, float, length, relative, ratio) {
    if kind == "x" { 
      translate = (0pt, position)
      position = bottom 
    }
    else if kind == "y" { 
      translate = (position, 0pt)
      position = left 
    }
    if mirror == auto { mirror = none }
  } else if type(position) == array {
    assert(position.len() == 2 and type(position.first()) == alignment, message: "Unexpected argument for axis `position`")
    (position, translate) = position
    if kind == "x" { translate = (0pt, translate) }
    else if kind == "y" { translate = (translate, 0pt) }
    if mirror == auto { mirror = none }
  } else if type(position) == alignment {
    if mirror == auto { mirror = none }
  }
  if ticks != auto {
    if type(ticks) == dictionary {
      assert("ticks" in ticks, message: "When passing a dictionary for `ticks`, you need to provide the keys \"ticks\" and optionally \"labels\"")
      locate-ticks = ticking.locate-ticks-manual.with(..ticks)
      if "labels" in ticks {
        format-ticks = ticking.format-ticks-manual.with(labels: ticks.labels) 
      }
    } else if type(ticks) == array {
      if ticks.len() > 0 and type(ticks.first()) == array {
        let (ticks, labels) = array.zip(..ticks)
        locate-ticks = ticking.locate-ticks-manual.with(ticks: ticks)
        format-ticks = ticking.format-ticks-manual.with(labels: labels) 
      } else {
        locate-ticks = ticking.locate-ticks-manual.with(ticks: ticks)
      }
    } else if ticks == none {
      locate-ticks = none
      format-ticks = none
    } else { assert(false, message: "The parameter `ticks` may either be an array or a dictionary")}
  }
  if locate-ticks == auto {
    locate-ticks = match(
      scale.name,
      "linear", () => ticking.locate-ticks-linear,
      "log", () => ticking.locate-ticks-log.with(base: scale.base),
      default: () => ticking.locate-ticks-linear,
    )
  }
  if format-ticks == auto {
    format-ticks = match(
      scale.name,
      "linear", () => ticking.format-ticks-linear,
      "log", () => ticking.format-ticks-log.with(base: scale.base),
      default: () => ticking.format-ticks-naive
    )
  }
  if subticks == none {
    locate-subticks = none
  } else if type(subticks) == int {
    locate-subticks = ticking.locate-subticks-linear.with(num: subticks)
  } else if subticks != auto {
    assert(false, message: "Unsupported argument type `" + str(type(subticks)) + "` for parameter `subticks`")
  }
  if locate-subticks == auto {
    locate-subticks = match(
      scale.name,
      "linear", () => ticking.locate-subticks-linear,
      "log", () => ticking.locate-subticks-log.with(base: scale.base),
      default: none
    )
  }
  let is-independant = plots.len() > 0
  if functions == auto { functions = (x => x, x => x) }
  else {
    assert(type(functions) == array and functions.map(type) == (function, function), message: "The parameter `functions` for `axis()` expects an array of two functions, a forward and an inverse function.")
    assert(plots.len() == 0, message: "An `axis()` can either be created with `functions` or with `..plots` but not both. ")
  }

  if type(lim) == array {
    assert.eq(lim.len(), 2, message: "Limit arrays must contain exactly two items")
    
  } else if lim == auto { 
    lim = (auto, auto)
  } else {
    assert(false, message: "Unsupported limit specification")
  }

  if mirror == auto {
    mirror = (ticks: true)
  }
  
  (
    type: "axis",
    scale: scale,
    lim: lim,
    functions: (forward: functions.at(0), inv: functions.at(1)),
    label: label,
    stroke: stroke,
    kind: kind,
    position: position,
    translate: translate,
    mirror: mirror,
      
    locate-ticks: locate-ticks,
    format-ticks: format-ticks,
    locate-subticks: locate-subticks,
    format-subticks: format-subticks,
    extra-ticks: extra-ticks,
    format-extra-ticks: format-extra-ticks,

    tick-args: tick-args,
    subtick-args: subtick-args,

    offset: offset,
    exponent: exponent,
    auto-exponent-threshold: auto-exponent-threshold,
    plots: plots,
    hidden: hidden,
  )
}

#let xaxis = axis.with(kind: "x")
#let yaxis = axis.with(kind: "y")


/// Computes the axis limits of one axis (x or y). For each plot, `xlimits()` 
/// and `ylimits()` is called. Plots whose limit functions return `none`  
/// will be ignored. 
/// If there are no plots or all calls to `xlimits()` and 
/// `ylimits()` return `none`, the limits are set to `(0,0)`.
///
/// Regardless of this, a zero-width range is enlarged by calling 
/// `next(min, -1)` and `next(max, 1)`. 
/// Finally lower and upper margins are applied. 
///
#let _axis-compute-limits(
  axis, 
  lower-margin: 0%, upper-margin: 0%,
  default-lim: (0,1),
) = {
  let is-independant = axis.plots.len() > 0
  let axis-type = match(axis.kind, "x", "x", "y", "y")
  let (x0, x1) = (none, none)
  let (tight0, tight1) = (true, true)
  

  if axis.lim.at(0) != auto { x0 = axis.lim.at(0); tight0 = true }
  if axis.lim.at(1) != auto { x1 = axis.lim.at(1); tight1 = true }
  
  if auto in axis.lim {
    if is-independant {
      let plot-limits = axis.plots.map(plot => plot.at(axis-type + "limits")())
        .filter(x => x != none)
      if plot-limits.len() == 0 {
        (x0, x1) = (0, 0)
      } else {
        for (plot-x0, plot-x1) in plot-limits {
          let tight-bound = (false, false)
          if type(plot-x0) == fraction { plot-x0 /= 1fr; tight-bound.at(0) = true }
          if axis.lim.at(0) == auto and (x0 == none or plot-x0 < x0) {
            x0 = plot-x0
            tight0 = tight-bound.at(0)
          }
          if type(plot-x1) == fraction { plot-x1 /= 1fr; tight-bound.at(1) = true }
          if axis.lim.at(1) == auto and (x1 == none or plot-x1 > x1) {
            x1 = plot-x1
            tight1 = tight-bound.at(1)
          }
        }
      }
    } else {
      (x0, x1) = default-lim.map(axis.functions.forward)
    }
  }
  if x0 == x1 {
    x0 = (axis.scale.inverse)((axis.scale.transform)(x0) - 1)
    x1 = (axis.scale.inverse)((axis.scale.transform)(x1) + 1)
  }



  let k0 = (axis.scale.transform)(x0)
  let k1 = (axis.scale.transform)(x1)
  let D = k1 - k0

  if not tight0 {
    x0 = (axis.scale.inverse)(k0 - D * lower-margin/100%)
  }
  if not tight1 {
    x1 = (axis.scale.inverse)(k1 + D * upper-margin/100%)
  }
  
  return (x0, x1)
}


/// Generates all ticks and subticks as well as their labels for an axis. 
/// 
/// -> dictionary
#let _axis-generate-ticks(
  /// The axis object. 
  /// -> lq.axis
  axis, 
  
  /// The length with which the axis will be displayed. This is for example used to determine automatic tick distances. 
  /// -> length
  length: 3cm
) = {
  let ticks = ()
  let tick-labels
  let subticks = ()
  let subtick-labels
  let (exp, offset) = (axis.exponent, axis.offset)

  let em = measure(line(length: 1em, angle: 0deg)).width
  axis.tick-args.num-ticks-suggestion = match(
    axis.kind,
    "x", length / (3 * em),
    "y", length / (2 * em)
  )
  let (x0, x1) = axis.lim

  if x0 != none {
    if axis.locate-ticks != none {
      let tick-info = (axis.locate-ticks)(x0, x1, ..axis.tick-args)
      ticks = tick-info.ticks
      (tick-labels, exp, offset) = match(
        axis.format-ticks,
        none, (none, 0, 0),
        default: () => (axis.format-ticks)(tick-info, exponent: axis.exponent, offset: axis.offset, auto-exponent-threshold: axis.auto-exponent-threshold),
      )
      

      if axis.locate-subticks != none {
        subticks = (axis.locate-subticks)(x0, x1, ..tick-info, ..axis.subtick-args)
        subtick-labels = match(
        axis.format-subticks,
        none, none,
        default: () => (axis.format-subticks)(ticks: subticks, exponent: axis.exponent, offset: axis.offset).at(0),
      )
      }
    } 
  }

  return (
    ticks: ticks,
    tick-labels: tick-labels,
    subticks: subticks,
    subtick-labels: subtick-labels,
    exp: exp,
    offset: offset
  )
}




#let draw-axis(
  axis,
  ticking,
  axis-style,
  e-get: none
) = {
  if axis.hidden { return (none, ()) }


  let (ticks, tick-labels, subticks, subtick-labels, exp, offset) = ticking
  
  let transform = axis.transform
  let axis-stroke = axis.stroke
  if axis-stroke != none {
    axis-stroke = update-stroke(axis-stroke, stroke(cap: "square"))
  }

  let place-tick 
  let place-exp-or-offset
  let spine
  let dim 
  let exp-or-offset-alignment
  let exp-or-offset-offset
  
  if axis.kind == "x" {
    dim = "height"
    place-tick = (x, label, position, inset, outset, stroke: axis.stroke) => {
      if axis.stroke != none {
        place-in-out(position, 
          line(length: inset + outset, angle: 90deg, stroke: stroke), 
          dx: x, dy: outset,
        )
      }
      if label == none { return }
  
      place-in-out(position, 
        place(center + position.inv().y, label), 
        dx: x, dy: .5em + outset
      )
    }
    place-exp-or-offset = it => place(horizon + right, dx: .5em, dy: 0pt, place(left + horizon, it))
    exp-or-offset-alignment = (alignment: bottom + right, content-alignment: horizon + left)
    exp-or-offset-offset = (dx: .5em, dy: 0pt)
    spine = line
  } else if axis.kind == "y" {
    dim = "width"
    place-tick = (y, label, position, inset, outset, stroke: axis.stroke) => {
      place(position, 
        line(length: inset + outset, stroke: stroke), 
        dy: y, dx: -outset
      )
      if label == none { return }
      
      let size = measure(label)
      let dx = size.width * 0
      place-in-out(position, 
        place(position.inv() + horizon, label), 
        dx: -dx - .5em + outset, dy: y,
      )
    }
    place-exp-or-offset = it => place(top + center, dx: 0pt, dy: -.5em, place(bottom + center, it))
    exp-or-offset-alignment = (alignment: top + left, content-alignment: center + bottom)
    exp-or-offset-offset = (dx: 0pt, dy: -.5em)
    spine = line.with(angle: 90deg)
  }



  let place-ticks(ticks, labels, position, display-tick-labels, length-coeff: 1, dim: "height") = {
    ticks = ticks.map(transform)
    if labels == none { labels = (none,) * ticks.len() }

    let content = ticks.zip(labels).map(
      ((tick, label)) => place-tick(tick, if not display-tick-labels {none} else {label}, position, length-coeff*axis-style.inset, length-coeff*axis-style.outset)
    ).join()
    
    let max-padding = axis-style.outset
    if display-tick-labels {
      let label-space = calc.max(..labels.map(label => measure(label).at(dim)), 0pt)
      max-padding += label-space
      if label-space > 0pt {
        max-padding += .5em
      }
    }
    
    return (content, max-padding)
  }
  

  let the-axis(
    position: axis.position,
    translate: (0pt, 0pt),
    display-ticks: true, 
    display-tick-labels: true, 
    display-axis-label: true,
    dim: "height"
  ) = {
    let content = none
    let max-padding = 0pt
    let bounds = ()

    if display-ticks {
      let (c, mp) = place-ticks(ticks, tick-labels, position, display-tick-labels, dim: dim)
      content += c
      max-padding = mp

      let (c, mp) = place-ticks(subticks, subtick-labels, position, display-tick-labels, length-coeff: .5, dim: dim)
      content += c

      if axis.extra-ticks != none {
        for tick in axis.extra-ticks {
          
          if type(tick) in (int, float) {
            tick = tick-constructor(tick)
          } 
          content += place-tick(transform(tick.pos), tick.label, position, tick.inside, tick.outside, stroke: if-auto(tick.stroke, axis.stroke))
        }
      }
    }
    if display-tick-labels {
      if type(exp) == int and exp != 0 {
        let (c, b) = place-with-bounds(
          {
            show "X": none
            zero.num("Xe" + str(exp))
          },
          ..exp-or-offset-offset, 
          ..exp-or-offset-alignment
        )
        content += c
        b = offset-bounds(b, translate)
        // bounds.push(b)
      }
      if type(offset) in (int, float) and offset != 0 {
        let (c, b) = place-with-bounds(
          zero.num(positive-sign: true, offset), 
          ..exp-or-offset-offset, 
          ..exp-or-offset-alignment
        )
        content += c
        b = offset-bounds(b, translate)
        bounds.push(b)
      }
    }
    
    if axis.label != none and display-axis-label {
      
      let get-settable-field(element, object, field) = {
        e.fields(object).at(field, default: e-get(element).at(field))
      }
      let label = axis.label
      if e.eid(label) != e.eid(lq-label) {
        let constructor = if dim == "height" {xlabel} else {ylabel}
        label = constructor(label)
      }
      let wrapper = if position in (top, bottom) {
        box.with(width: 100%)
      } else if position in (left, right) {
        box.with(height: 100%)
      }

      let dx = if-auto(get-settable-field(lq-label, label, "dx"), 0pt)
      let dy = if-auto(get-settable-field(lq-label, label, "dy"), 0pt)
      let pad = if-auto(get-settable-field(lq-label, label, "pad"), 0pt) + max-padding


      let body = wrapper(label)
      let size = measure(body)

      let (label, b) = place-with-bounds(body, alignment: position, dx: dx, dy: dy, pad: pad)
      
      content += label
      if dim == "height" {
        max-padding = size.height + pad
      } else {
        max-padding = size.width + pad
      }
    }
    if axis-stroke != none {
      content += (spine(length: 100%, stroke: axis-stroke))
    }
    
    let main-bounds = create-bounds()
    if axis.kind == "x" {
      main-bounds.right = 100%
      if position == top {
        main-bounds.top = -max-padding
        main-bounds.bottom = axis-style.inset
      } else if position == bottom {
        main-bounds.bottom = 100% + max-padding
        main-bounds.top = 100% - axis-style.inset
      }
    } else {
      main-bounds.bottom = 100%
      if position == left {
        main-bounds.left = -max-padding
        main-bounds.right = axis-style.inset
      } else if position == right {
        main-bounds.right = 100% + max-padding
        main-bounds.left = 100% - axis-style.inset
      }
    }
    main-bounds = offset-bounds(main-bounds, translate)
    bounds.push(main-bounds)
    return (content, bounds)
  }

  let (axis-content, bounds) = the-axis(dim: dim, translate: axis.translate)
  let content = place(axis.position, axis-content, dx: axis.translate.at(0), dy: axis.translate.at(1))
  let em = measure(line(length: 1em, angle: 0deg)).width
  
  
  if axis.mirror != none {
    let (mirror-axis-content, mirror-axis-bounds) = the-axis(
      dim: dim,
      position: axis.position.inv(),
      translate: axis.translate,
      display-ticks: axis.mirror.at("ticks", default: false),
      display-tick-labels: axis.mirror.at("ticklabels", default: false),
      display-axis-label: axis.mirror.at("label", default: false),
    )
    content += place(axis.position.inv(), mirror-axis-content)
    bounds += mirror-axis-bounds
  }
  
  return (content, bounds)
}
