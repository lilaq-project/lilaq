#import "utility.typ": match-type
#import "scale.typ"
#import "diagram.typ": diagram
#import "plot-primitives.typ": rect
#import "math.typ" as pmath

#let create-normalized-colors(
  values,
  colormap,
  norm,
  vmin: auto, 
  vmax: auto,
  ignore-nan: false
) = {
  if ignore-nan {
    if vmin == auto { vmin = pmath.cmin(values) }
    if vmax == auto { vmax = pmath.cmax(values) }
  } else {
    if vmin == auto { vmin = calc.min(..values) }
    if vmax == auto { vmax = calc.max(..values) }
  }
  if vmin == vmax { vmin -= 1; vmax += 1}

  let norm-fn = match-type(
    norm,
    function: norm,
    string: () => scale.scales.at(norm).transform,
    dictionary: () => {
      assert("transform" in norm, message: "The argument `norm` must be a valid scale from the `scales` module")
      norm.transform
    },
    default: () => assert(false, message: "Unsupported type `" + str(type(norm)) + "` for argument `norm`")
  )
  
  let normalize = scale.create-trafo(norm-fn, vmin, vmax)
  assert(type(colormap) in (gradient, array), message: "Invalid type for colormap")
  if type(colormap) == array {
    colormap = gradient.linear(..colormap)
  }
  (values.map(x => colormap.sample(normalize(x) * 100%)), (norm: norm, min: vmin, max: vmax, colormap: colormap))
}




#let colorbar(plot) = {
  let cinfo = plot.cinfo
  diagram(
    width: .3cm, 
    xaxis: (ticks: none), 
    yaxis: (position: right, mirror: (:)),
    grid: none,
    // ylabel: "color",
    ylim: (cinfo.min, cinfo.max),
    yscale: cinfo.norm,
    rect(0%, 0%, width: 100%, height: 100%, fill: gradient.linear(..cinfo.colormap.stops(), angle: -90deg))
  )
}