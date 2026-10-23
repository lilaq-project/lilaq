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
  
  // Contour plots require special treatment because they map discrete levels to colors. 
  // We identify contour plots by the presence of the `levels` array in the plot object.
  let is-discrete-contour = "levels" in plot and plot.at("is-filled", default: none)
  let is-line-contour = "levels" in plot and not plot.at("is-filled", default: none)
  
  if is-discrete-contour {
    
    for i in range(plot.levels.len()) {
      let bottom = plot.levels.at(i)
      let top = cinfo.max
      
      if top > bottom {
        // Render layers as stacked geometric primitives extending to the upper bound.
        // This layering approach replicates the rendering logic of the actual contour plot, 
        // effectively eliminating anti-aliasing artifacts between boundaries 
        // while maintaining mathematically precise alignment with the tick marks.
        let color = plot.level-colors.at(i)
        let fill = plot.fill.at(i)
        
        
        let rect = if orientation == "vertical" {
          fill => rect(
            0%,
            bottom,
            width: 100%,
            height: top - bottom,
            fill: fill,
          )
        } else {
          fill => rect(
            bottom,
            0%,
            width: top - bottom,
            height: 100%,
            fill: fill,
          )
        }

        grad.push(rect(color))
        if fill != auto {
          grad.push(rect(fill))
        }
      }
    }
  } else if is-line-contour {
    // For unfilled contour plots, we draw discrete lines at the specific levels.
    // The stroke styling (e.g. thickness) is inherited from the plot's general stroke 
    // and combined with the specific level color.
    import "../plot/hlines.typ": hlines
    import "../plot/vlines.typ": vlines
    import "../process-styles.typ": merge-strokes
    
    let levels = plot.levels
    let colors = plot.level-colors
    
    for i in range(levels.len()) {
      let level = levels.at(i)
      let merged = merge-strokes(stroke(dash: "solid"), plot.stroke.at(i), colors.at(i))
      
      if orientation == "vertical" {
        grad.push(hlines(level, stroke: merged))
      } else {
        grad.push(vlines(level, stroke: merged))
      }
    }
  } else {
    // Standard continuous colorbar for plots like scatter or colormesh
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
      ylim: (cinfo.min, cinfo.max),
      ylabel: label
    )
  } else if orientation == "horizontal" {
    preset-args = (
      height: thickness,
      yaxis: (ticks: none),
      xaxis: (position: bottom, mirror: (:)),
      xscale: cinfo.norm,
      xlim: (cinfo.min, cinfo.max),
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