#import "../assertations.typ"
#import "../math.typ": sign, mesh
#import "../logic/sample-colors.typ": sample-colors
#import "../process-styles.typ": twod-ify-alignment

#let are-dimensions-all-equal(data) = {
  if data.len() <= 1 { return true }
  let x0 = data.first()
  return data.slice(1).all(x => calc.abs(1 - x/x0) < 1e-8)
}

#assert(are-dimensions-all-equal((1, 1, 1)))
#assert(not are-dimensions-all-equal((1, 1, 2)))
#assert(not are-dimensions-all-equal((1, 1, 1.0001)))
#assert(are-dimensions-all-equal((1, 1, 1.000000001)))



#let render-colormesh(plot, transform) = {
  if "make-legend" in plot {
    return box(width: 100%, height: 100%, fill: plot.color.at(0))
  }

  if type(plot.z) == content {
    let x0 = plot.x.first()
    let x1 = plot.x.last()
    let y0 = plot.x.first()
    let y1 = plot.x.last()

    let (xx0, yy0) = transform(x0, y0)
    let (xx1, yy1) = transform(x1, y1)
    let image = scale(
      x: xx1 - xx0, 
      y: yy1 - yy0, 
      plot.z,
      origin: left + top
    )
    

    return place(
      top + left,
      dx: xx0, dy: yy0,
      image
    )
  }

  let get-extents(a) = {
    a.zip(a.slice(1)).map(((a, a1)) => a1 - a)
  }

  let get-size(i, a) = {
    if i < a.len() - 1 { 
      let diff = a.at(i + 1) - a.at(i)
      if i > 0 {
        (a.at(i) - a.at(i - 1), diff)
      } else {
        (diff, diff)
      }
    }
    else { 
      let diff = a.at(-1) - a.at(-2)
      (diff, diff)
    }
  }

  let widths = get-extents(plot.x)
  let heights = get-extents(plot.y)

  if are-dimensions-all-equal(widths) and are-dimensions-all-equal(heights) and false {

    let img = image(
      bytes(plot.color.map(c => rgb(c).components().map(x => int(x / 100% * 255))).join()),
      format: (
        encoding: "rgba8",
        width: plot.x.len(),
        height: plot.y.len(),
      ),
      scaling: plot.interpolation,
      fit: "stretch",
    )

    
    let (x0, xn) = (plot.x.at(0), plot.x.at(-1))
    let (y0, yn) = (plot.y.at(0), plot.y.at(-1))

    let w = widths.at(0)
    let h = heights.at(0)
    let (x1, y1) = transform(x0, y0)
    let (x2, y2) = transform(xn + w, yn + h)
    
    img = scale(
      origin: top + left,
      x: x2 - x1,
      y: y2 - y1,
      img
    )
    place(
      top + left,
      dx: x1, 
      dy: y1, 
      img
    )

  } else {
    // assert(
    //   plot.interpolation == "pixelated", 
    //   message: "For non-evenly-spaced color meshes, currently only the interpolation option \"pixelated\" is supported. "
    // )

    for i in range(plot.x.len() - 1) {
      for j in range(plot.y.len() - 1) {
        let x = plot.x.at(i)
        let y = plot.y.at(j)
        
        let (w1, w2) = get-size(i, plot.x)
        let (h1, h2) = get-size(j, plot.y)
        let (x1, y1) = transform(x, y)

        let (x2, y2) = transform(plot.x.at(i+1), plot.y.at(j+1))
        let fill = plot.color.at(i + j * (plot.x.len() - 1))
        let width = x2 - x1
        let height = y2 - y1
        place(
          dx: x1, dy: y1, 
          rect(width: width * 1.01, height: height * 1.01, fill: fill)
        )
      }
    }

  }
}


/// Plots a rectangular color mesh, e.g., a heatmap. 
/// ```example
/// #lq.diagram(
///   width: 4cm, height: 4cm,
///   lq.colormesh(
///     lq.linspace(-4, 4, num: 10),
///     lq.linspace(-4, 4, num: 10),
///     (x, y) => x * y, 
///     map: color.map.magma
///   )
/// )
/// ```
/// 
/// When the input `x` and `y` coordinate arrays are both evenly spaced, an 
/// image is drawn instead of individual rectangles. This reduces the file size
/// and improves rendering in most cases. When either array is not evenly
/// spaced, the entire color mesh is drawn with individual rectangles. 
/// 
#let colormesh(
  
  /// A one-dimensional array of $x$ coordinates. 
  /// -> array
  x, 
  
  /// A one-dimensional array of $y$ coordinates. 
  /// -> array
  y, 

  /// Specifies the $z$ coordinates (height) for all combinations of $x$ and $y$ 
  /// coordinates. This can either be a 
  /// - two-dimensional $m×n$-array where $m$ is the length of @colormesh.y 
  ///   and $n$ is the length of @colormesh.x (for each $y$ value, a row of $x$
  ///   values), 
  /// - or a function that takes an `x` and a `y` value and returns a 
  ///   corresponding `z` coordinate. 
  /// Also see the function @mesh that can be used to create such meshes. 
  /// 
  /// For masking, you can use `float.nan` values to hide individual cells of the color mesh. 
  /// -> array | function
  z,
  
  /// A color map in the form of a gradient or an array of colors to sample from. 
  /// -> array | gradient
  map: color.map.viridis,

  /// Sets the data value that corresponds to the first color of the color map.
  /// If set to `auto`, it defaults to the minimum $z$ value.
  /// -> auto | int | float
  min: auto,

  /// Sets the data value that corresponds to the last color of the color map.
  /// If set to `auto`, it defaults to the maximum $z$ value.
  /// -> auto | int | float
  max: auto,

  /// Determines how values outside the range defined by @colormesh.min and 
  /// @colormesh.max are handled.
  /// 
  /// - `"clamp"`: Values below @colormesh.min are mapped to the first color of
  ///   the color map, values above @colormesh.max are mapped to the last color. 
  /// - `"mask"`: Values outside the range are not drawn and appear transparent. 
  /// 
  /// -> "clamp" | "mask"
  excess: "clamp",

  /// The normalization method used to scale $z$ coordinates to the range 
  /// $[0,1]$ before mapping them to colors using the color map. This can be a 
  /// @scale, a string that is the identifier of a built-in scale or a function 
  /// that takes one argument (for example the argument `x => calc.log(x)` 
  /// would be equivalent to passing `"log"`). Note that the function does not 
  /// actually need to map the values to the interval $[0,1]$. Instead it 
  /// describes a scaling that is applied before the data set is _linearly_ 
  /// scaled to the interval $[0,1]$. 
  /// -> lq.scale | str | function
  norm: "linear",

  align: center + horizon,

  /// Whether to apply smoothing or leave the color mesh pixelated. This is 
  /// currently only supported when @colormesh.x and @colormesh.y are evenly 
  /// spaced. 
  /// -> "pixelated" | "smooth"
  interpolation: "pixelated",
  
  /// The legend label for this plot. See @plot.label. 
  /// -> content
  label: none,
  
  /// Determines the $z$ position of this plot in the order of rendered diagram
  /// objects. See @plot.z-index.  
  /// -> int | float
  z-index: 2

) = {

  if type(z) == function {
    z = mesh(x, y, z)
  }

  assert(
    excess in ("clamp", "mask"), 
    message: "`colormesh`: Invalid value for argument `excess`. Expected \"clamp\" or \"mask\", found \"" + str(excess) + "\""
  )


  let cinfo
  let color

  let offset-to-middle(data) = {
    import "../vec.typ"
    let diffs = data.windows(2).map(((a, b)) => (b - a)/2)
    diffs.push(diffs.at(-1, default: 1))
    vec.subtract(data, diffs)
  }

  align = twod-ify-alignment(align)
  if align.x == center {
    x = offset-to-middle(x)
  }
  if align.y == horizon {
    y = offset-to-middle(y)
  }
  x.push(x.at(-1) + (x.at(-1) - x.at(-2)))
  y.push(y.at(-1) + (y.at(-1) - y.at(-2)))

  if type(z) == content {
    // z.fields().width
  } else {


    assert(
      type(z) == content or (type(z) == array and type(z.first()) == array), 
      message: "`colormesh`: `z` expects a 2D array or an image"
    )

    // assert.eq(
    //   y.len(), z.len(), 
    //   message: "`colormesh`: The number of `y` coordinates and the number of rows in `z` must match. Found " + str(y.len()) + " != " + str(z.len())
    // )
    // assert.eq(
    //   x.len(), z.first().len(), 
    //   message: "`colormesh`: The number of `x` coordinates and the row length in `z` must match. Found " + str(x.len()) + " != " + str(z.first().len())
    // )


    color = z.flatten()

    if type(color.at(0, default: 0)) in (int, float) {
      (color, cinfo) = sample-colors(
        color, 
        map, 
        norm, 
        ignore-nan: true, 
        min: min, 
        max: max,
        excess: excess
      )
    }
  }
  
  (
    cinfo: cinfo,
    x: x,
    y: y,
    z: z,
    label: label,
    color: color,
    align: align,
    plot: render-colormesh,
    interpolation: interpolation,
    xlimits: () => (
      1fr * x.at(0), 
      1fr * (x.at(-1) /*+ (x.at(-1) - x.at(-2))*/)
    ),
    ylimits: () => (
      1fr * y.at(0), 
      1fr * (y.at(-1) /*+ (y.at(-1) - y.at(-2))*/)
    ),
    legend: true,
    z-index: z-index
  )
}
