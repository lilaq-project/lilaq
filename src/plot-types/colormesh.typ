#import "../assertations.typ"
#import "../math.typ": sign
#import "../color.typ": create-normalized-colors

#let render-colormesh(plot, transform) = {
  let get-widths(x) = {
    x.zip(x.slice(1)).map(((x, x1)) => x1 - x)
  }
  let get-size(i, x) = {
    if i < x.len() - 1 { 
      let d2 = x.at(i + 1) - x.at(i)
      if i > 0 {
        (x.at(i) - x.at(i - 1), d2)
      } else {
        (d2, d2)
      }
    }
    else { 
      let d = x.at(-1) - x.at(-2)
      (d, d)
    }
  }
  let widths = get-widths(plot.x)
  let heights = get-widths(plot.x)
  for i in range(plot.x.len()) {
    for j in range(plot.y.len()) {
      if float.is-nan(plot.z.at(i).at(j)) { continue }
      let x = plot.x.at(i)
      let y = plot.y.at(j)
      
      let (w1, w2) = get-size(i, plot.x)
      let (h1, h2) = get-size(j, plot.y)
      let (x1, y1) = transform(x - w1/2, y + h2/2)
      let (x2, y2) = transform(x + w2/2, y - h1/2)
      let fill = plot.color.at(j + i*plot.y.len())
      let width = x2 - x1
      let height = y2 - y1
      place(dx: x1, dy: y1, rect(width: width, height: height, fill: fill))
    }
  }
}


/// Creates a color mesh plot. 
/// ```example
/// #lq.diagram(
///   width: 4cm, height: 4cm,
///   lq.colormesh(
///     lq.linspace(-4, 4, num: 10),
///     lq.linspace(-4, 4, num: 10),
///     (x, y) => x*y, 
///     map: color.map.magma
///   )
/// )
/// ```
#let colormesh(
  
  /// A one-dimensional array of $x$ data coordinates. 
  /// -> array
  x, 
  
  /// A one-dimensional array of $y$ data coordinates. 
  /// -> array
  y, 


  /// Specifies the $z$ coordinates (height) for all combinations of $x$ and $y$ 
  /// coordinates. This can either be a two-dimensional array of dimensions $m×n$ 
  /// where $m$ is the length of @colormesh.x and $n$ is the length of @colormesh.y, 
  /// or a function that takes an `x` and a `y` value and returns a corresponding 
  /// `z` coordinate. Also see the function @mesh for creating meshes. 
  /// -> array | function
  z,
  
  /// A color map in form of a gradient or an array of colors to sample from. 
  /// -> array | gradient
  map: color.map.viridis,

  /// Sets the data value that corresponds to the first color of the color map. If set 
  /// to `auto`, it defaults to the minimum $z$ value.
  /// -> auto | int | float
  vmin: auto,

  /// Sets the data value that corresponds to the last color of the color map. If set 
  /// to `auto`, it defaults to the maximum $z$ value.
  /// -> auto | int | float
  vmax: auto,

  /// The normalization method used to scale $z$ coordinates to the range 
  /// $[0,1]$ before mapping them to colors using the color map. This can be a 
  /// `lq.scale`, a string that is the identifier of a built-in scale or a function 
  /// that takes one argument. 
  /// -> lq.scale | str | function
  norm: "linear",
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram objects. 
  /// See @plot.z-index.  
  /// -> int | float
  z-index: 2

) = {
  if type(z) == function {
    z = x.map(x => y.map(y => z(x, y)))
  }
  let color = z.flatten()
  assert.eq(x.len() * y.len(), color.len())
  let cinfo
  if type(color) == array { 
    if type(color.at(0, default: 0)) in (int, float) {
      
      (color, cinfo) = create-normalized-colors(color, map, norm, ignore-nan: true, vmin: vmin, vmax: vmax)
    }
  }
  
  (
    cinfo: cinfo,
    x: x,
    y: y,
    z: z,
    label: label,
    color: color,
    plot: render-colormesh,
    xlimits: () => (
      1fr * (x.at(0) - 0.5 * (x.at(1) - x.at(0))), 
      1fr * (x.at(-1) + 0.5 * (x.at(-1) - x.at(-2)))
    ),
    ylimits: () => (
      1fr * (y.at(0) - 0.5 * (y.at(1) - y.at(0))), 
      1fr * (y.at(-1) + 0.5 * (y.at(-1) - y.at(-2)))
    ),
    legend-handle: plot => box(width: 100%, height: 100%, fill: color.at(0)),
    z-index: z-index
  )
}
