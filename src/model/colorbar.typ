#import "diagram.typ": diagram
#import "../plot/rect.typ": rect

#import "../typing.typ": set-diagram


/// Creates a visual representation of the color mapping used in a plot 
/// instance like @scatter or @colormesh. 
/// 
/// This generates a new (usually slim) diagram with a filled gradient 
/// according to the color map used in the plot, appropriate ticks, and 
/// optionally a label. This diagram can be configured through general `set`
/// rules on @diagram and through additional arguments passed through 
/// @colorbar.args. 
/// 
/// ```example
/// #show: lq.set-diagram(height: 3.5cm, width: 4cm)
/// 
/// #let mesh = lq.colormesh(
///   lq.linspace(-0.3, 1.3),
///   lq.linspace(-0.3, 1.3),
///   (x, y) => x * y,
///   map: gradient.linear(..color.map.icefire).sharp(9)
/// )
/// 
/// #lq.diagram(
///   mesh
/// )
/// #lq.colorbar(mesh, thickness: 2mm)
/// ```
/// 
/// The color bar is a separate inline object and can be placed anywhere in the 
/// document. Note that if the example above were in code mode, Typst would 
/// place the color bar directly after the diagram with no space in-between. 
/// You can insert a manual space through `h(.5em)` (or similar). 
/// 
/// Also, the color bar has a fixed length by default and does not know about 
/// the dimensions of the previous diagram. In order to guarentee the same 
/// height, it is advisable to use a set rule on `diagram` (as demonstrated 
/// above) to set the height for both the diagram and the color bar at once. 
#let colorbar(

  /// A plot instance that uses color-coding, e.g., @scatter, @colormesh, @contour, and @quiver. 
  /// -> plot
  plot,


  /// How to orient the colorbar. 
  /// -> "vertical" | "horizontal"
  orientation: "vertical",

  /// The thickness of the colorbar. 
  /// -> length
  thickness: 3mm,

  /// A label to place on the axis. 
  /// -> content
  label: none,

  /// Additional arguments to pass to @diagram. 
  /// -> any
  ..args

) = {
  let cinfo = plot.cinfo
  
  let grad = ()
  let is-discrete-contour = "levels" in plot and plot.at("fill", default: false)
  let is-line-contour = "levels" in plot and not plot.at("fill", default: false)
  
  if is-discrete-contour {
    import "../logic/transform.typ": create-trafo
    import "../utility.typ": match-type
    import "../logic/scale.typ"
    
    let norm-fn = match-type(
      cinfo.norm,
      function: () => cinfo.norm,
      string: () => scale.scales.at(cinfo.norm).transform,
      dictionary: () => cinfo.norm.transform,
      default: () => assert(false),
    )
    let normalize = create-trafo(norm-fn, cinfo.min, cinfo.max)
    
    let levels = plot.levels
    let colors = plot.line-colors
    let stops = ()
    
    for i in range(levels.len()) {
      let bottom = levels.at(i)
      let top = if i < levels.len() - 1 { levels.at(i + 1) } else { calc.max(cinfo.max, bottom) }
      if top > bottom {
        let bottom-pct = calc.clamp(normalize(bottom), 0.0, 1.0) * 100%
        let top-pct = calc.clamp(normalize(top), 0.0, 1.0) * 100%
        stops.push((colors.at(i), bottom-pct))
        stops.push((colors.at(i), top-pct))
      }
    }
    
    grad.push(rect(
      if orientation == "vertical" { 0% } else { cinfo.min },
      if orientation == "vertical" { cinfo.min } else { 0% },
      width: if orientation == "vertical" { 100% } else { cinfo.max - cinfo.min },
      height: if orientation == "vertical" { cinfo.max - cinfo.min } else { 100% },
      fill: gradient.linear(
        ..stops,
        angle: if orientation == "vertical" { 90deg } else { 0deg },
      ),
      stroke: none,
    ))
  } else if is-line-contour {
    import "../plot/hlines.typ": hlines
    import "../plot/vlines.typ": vlines
    import "../process-styles.typ": merge-strokes
    
    let levels = plot.levels
    let colors = plot.line-colors
    let plot-stroke = plot.at("stroke", default: auto)
    
    for i in range(levels.len()) {
      let level = levels.at(i)
      let merged = merge-strokes(plot-stroke, colors.at(i))
      
      if orientation == "vertical" {
        grad.push(hlines(level, stroke: merged))
      } else {
        grad.push(vlines(level, stroke: merged))
      }
    }
    
    grad.push(rect(
      if orientation == "vertical" { 0% } else { cinfo.min },
      if orientation == "vertical" { cinfo.min } else { 0% },
      width: if orientation == "vertical" { 100% } else { cinfo.max - cinfo.min },
      height: if orientation == "vertical" { cinfo.max - cinfo.min } else { 100% },
      fill: none,
      stroke: none,
    ))
  } else {
    if orientation == "vertical" {
      grad.push(rect(
        0%,
        cinfo.min,
        width: 100%,
        height: cinfo.max - cinfo.min,
        fill: gradient.linear(
          ..cinfo.colormap.stops(),
          angle: 90deg,
        ),
      ))
    } else if orientation == "horizontal" {
      grad.push(rect(
        cinfo.min,
        0%,
        height: 100%,
        width: cinfo.max - cinfo.min,
        fill: gradient.linear(
          ..cinfo.colormap.stops(),
          angle: 0deg,
        ),
      ))
    }
  }
  
  let preset-args = (:)
  if orientation == "vertical" {
    preset-args = (
      width: thickness,
      xaxis: (ticks: none),
      yaxis: (position: right, mirror: (:)),
      yscale: cinfo.norm,
      ylabel: label
    )
  } else if orientation == "horizontal" {
    preset-args = (
      height: thickness,
      yaxis: (ticks: none),
      xaxis: (position: bottom, mirror: (:)),
      xscale: cinfo.norm,
      xlabel: label
    )
  } else {
    assert(false, message: "Unexpected orientation \"" + orientation + "\", possible values are \"horizontal\" and \"vertical\"")
  }

  

  diagram(
    grid: none,
    margin: 0%,
    ..preset-args,
    ..args,
    ..grad,
  )
}