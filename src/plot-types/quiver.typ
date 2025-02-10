#import "../assertations.typ"
#import "../color.typ": create-normalized-colors
#import "../plot-utils.typ": match, match-type, merge-strokes
#import "../math.typ": vec
#import "../utility.typ": if-auto
#import "../cycle.typ": style

#import "@preview/tiptoe:0.1.0"



#let render-quiver(plot, transform) = context {


  let pivot = match(plot.style.pivot,
    center, () => dir => dir.map(x => -x*0.5),
    start, () => dir => (0, 0),
    end, () => dir => dir.map(x => -x),
    default: () => assert(false, message: "The argument `pivot` of `quiver` needs to be one of 'start', 'center', or 'end'")
  )



  let arrow = plot.style.arrow
  let get-arrow-stroke = plot.style.get-arrow-stroke

  for i in range(plot.x.len()) {
    for j in range(plot.y.len()) {
      let dir = plot.directions.at(i).at(j)
      if dir.any(float.is-nan) { continue }
      
      let x = plot.x.at(i)
      let y = plot.y.at(j)
      dir = vec.multiply(dir, plot.scale)
      let length = calc.sqrt(dir.map(x => x*x).sum())
      let start = vec.add((x, y), pivot(dir))
      let end = vec.add(start, dir)

      let stroke = get-arrow-stroke(j + i*plot.y.len(), length)
      
      if length == 0 {
        let (x, y) = transform(..start)
        let radius = plot.style.thickness / 2 
        place(
          dx: x - radius, dy: y - radius,
          circle(radius: radius, fill: stroke.paint)
        )
        continue
      }

      place(
        arrow(
          start: transform(..start), 
          end: transform(..end), 
          stroke: stroke
        )
      )
    }
  }
}

/// Creates a quiver plot. 
#let quiver(

  /// A one-dimensional array of $x$ data coordinates. 
  /// -> array
  x, 
  
  /// A one-dimensional array of $y$ data coordinates. 
  /// -> array
  y, 

  /// Direction vectors for the arrows. 
  /// This can either be a two-dimensional array of dimensions $m×n$ 
  /// where $m$ is the length of @quiver.x and $n$ is the length of @quiver.y, 
  /// or a function that takes an `x` and a `y` value and returns a 
  /// corresponding 2-dimensional vector. 
  /// -> array | function
  directions,

  /// How to color the arrows. This can be a single color or a 2d arrow with the same dimensions as @quiver or a function that receives `(x, y)` pairs from the given `x` and `y` coordinates and returns a scalar/color. 
  /// -> color | array | function
  color: black,

  /// How to stroke the arrows. This parameter takes precedence over @quiver.color. 
  /// -> auto | stroke
  stroke: auto,

  /// Determines the arrow tip to use. This expects a mark as specified by
  /// the #link("https://typst.app/universe/package/tiptoe")[tiptoe package]. 
  /// -> none | tiptoe.mark
  tip: tiptoe.stealth.with(length: 400%),
  
  /// Determines the arrow tail to use. This expects a mark as specified by 
  /// the #link("https://typst.app/universe/package/tiptoe")[tiptoe package]. 
  /// -> none | tiptoe.mark
  toe: none,

  /// With what part the arrows should point onto the grid coordinates, e.g., when set to `end`, the tip (end) of the arrow will point the respective coordinates. 
  /// -> start | center | end
  pivot: end,  

  /// Scales the length of the arrows uniformly
  /// -> auto | int | float
  scale: auto, 
  
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
  /// @scale, a string that is the identifier of a built-in scale or a function 
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
  
  if type(directions) == function {
    directions = x.map(x => y.map(y => directions(x, y)))
  }
  
  if type(color) == function {
    color = x.map(x => y.map(y => color(x, y)))
  }
  
  if type(color) == array { 
    assert(type(color.first()) == array, message: "The argument `color` for `quiver` either needs to be a single value or a 2D array")
    let color-flat = color.flatten()
    assert(x.len() * y.len() == color-flat.len(), message: "The number of elements in `color` does not match the grid for `quiver()`")
    
    if type(color-flat.at(0, default: 0)) in (int, float) {
      let cinfo
      (color, cinfo) = create-normalized-colors(color-flat, map, norm, ignore-nan: true, vmin: vmin, vmax: vmax)
    }
  }

  if scale == auto {
    let lengths = directions.join().map(a => calc.sqrt(a.map(b => b*b).sum()))
    lengths = lengths.filter(x => not float.is-nan(x))
    
    let n = lengths.len()
    let average = lengths.sum() / n
    let compensation = calc.max(4., calc.pow(n, .6) * .6)
    
    scale = 1 / (0.54 * average * compensation)
  }

  if stroke != auto { stroke = std.stroke(stroke) }
  
  let thickness = match-type(
    stroke,
    stroke: () => if-auto(stroke.thickness, 1pt),
    auto-type: 1pt
  )


  let get-stroke = {
    if stroke != auto and stroke.thickness != auto { 
    let p = stroke
      (color, length) => merge-strokes(stroke, color) 
    } else {
    (color, length) => merge-strokes(
      1pt*calc.clamp(4 * length, .2, 1), 
      stroke, color
    )
    }
  }

  
  let get-arrow-stroke = match-type(
    color,
    panic: true,
    color: () => (i, len) => get-stroke(color, len),
    array: () => (i, len) => get-stroke(color.at(i), len),
  )
  let arrow = tiptoe.line.with(tip: tip, toe: toe)
  
  (
    x: x,
    y: y,
    directions: directions,
    scale: scale,
    label: label,
    style: (
      thickness: thickness,
      pivot: pivot, 
      color: color,
      arrow: arrow,
      get-arrow-stroke: get-arrow-stroke
    ),
    plot: render-quiver,
    xlimits: () => (x.at(0), x.at(-1)),
    ylimits: () => (y.at(0), y.at(-1)),
    legend-handle: plot => layout(size => {
      arrow(
        length: size.width, 
        stroke: get-arrow-stroke(0, 1)
      )
    }),
    z-index: z-index
  )
}
