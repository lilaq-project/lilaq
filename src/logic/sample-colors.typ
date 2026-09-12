
#import "../utility.typ": match-type
#import "../math.typ" as pmath
#import "../logic/scale.typ"
#import "../logic/transform.typ": create-trafo


#let _get-normalize(norm, min, max) = {
  let norm-fn = match-type(
    norm,
    function: () => norm,
    string: () => scale.scales.at(norm).transform,
    dictionary: () => {
      assert("transform" in norm, message: "The argument `norm` must be a valid scale from the `scales` module")
      norm.transform
    },
    default: () => assert(false, message: "Unsupported type `" + str(type(norm)) + "` for argument `norm`")
  )
  return create-trafo(norm-fn, min, max)
}

#let sample-colors(
  values,
  colormap,
  norm,
  min: auto, 
  max: auto,
  ignore-nan: false,
  excess: "clamp"  // "clamp" | "mask"
) = {
  if ignore-nan {
    if min == auto { min = pmath.cmin(values) }
    if max == auto { max = pmath.cmax(values) }
  } else {
    if min == auto { min = calc.min(..values) }
    if max == auto { max = calc.max(..values) }
  }
  if min == max { min -= 1; max += 1}

  if excess == "mask" {
    values = values.map(v => if v < min or v > max { float.nan } else { v })
  } else if excess == "clamp" {
    // values = values.map(v => if v < min { min } else if v > max { max } else { v })
  }

  let normalize = _get-normalize(norm, min, max)
  assert(type(colormap) in (gradient, array), message: "Invalid type for colormap")
  if type(colormap) == array {
    colormap = gradient.linear(..colormap)
  }
  let convert-scalar-to-color(x) = {
    if float.is-nan(x) { return luma(0, 0%) }
    colormap.sample(normalize(x) * 100%)
  }
  (
    values.map(convert-scalar-to-color), 
    (norm: norm, min: min, max: max, colormap: colormap)
  )
}


/// Creates a sharp step gradient based on discrete levels and colors.
#let create-discrete-gradient(levels, colors, cinfo, angle: 0deg) = {
  let normalize = _get-normalize(cinfo.norm, cinfo.min, cinfo.max)
  
  // Sort levels and colors together to ensure non-overlapping intervals
  let combined = levels.zip(colors).sorted(key: x => x.at(0))
  let sorted-levels = combined.map(x => x.at(0))
  let sorted-colors = combined.map(x => x.at(1))

  let stops = ()
  for i in range(sorted-levels.len()) {
    let bottom = sorted-levels.at(i)
    let top = if i < sorted-levels.len() - 1 { sorted-levels.at(i + 1) } else { calc.max(cinfo.max, bottom) }
    if top > bottom {
      let bottom-pct = calc.clamp(normalize(bottom), 0.0, 1.0) * 100%
      let top-pct = calc.clamp(normalize(top), 0.0, 1.0) * 100%
      stops.push((sorted-colors.at(i), bottom-pct))
      stops.push((sorted-colors.at(i), top-pct))
    }
  }
  
  if stops.len() == 0 {
    return rgb(0, 0, 0, 0)
  }
  
  // Sort stops by percentage to guarantee monotonicity (especially for reversed scales)
  stops = stops.sorted(key: x => x.at(1))
  
  if stops.first().at(1) > 0% {
    let first-color = stops.first().at(0)
    let first-pct = stops.first().at(1)
    stops.insert(0, (first-color, first-pct))
    stops.insert(0, (first-color, 0%))
  }

  if stops.last().at(1) < 100% {
    let last-color = stops.last().at(0)
    let last-pct = stops.last().at(1)
    stops.push((last-color, last-pct))
    stops.push((last-color, 100%))
  }
  return gradient.linear(..stops, angle: angle)
}
