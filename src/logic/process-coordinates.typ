
/// Takes an array of points as input and filters all points where at least one
/// coordinate is `calc.nan` to produce
/// + a filtered copy of the input array
/// + an array of consecutive "runs", i.e., all connected sequences from the input
///   separated by points where one or more coordinates take the value `calc.nan`. 
/// 
/// -> array
#let filter-nan-points(
  
  /// Input points. The points themselves may have any dimension.
  /// -> array
  points, 
  
  /// Whether to to split the data into separate runs whenever a coordinate 
  /// containing a `float.nan` value is encountered.  
  /// -> bool
  generate-runs: false
  
) = {
  if generate-runs {
    let filtered-points = ()
    let runs = ((),)
    for coord in points {
      if coord.find(float.is-nan) != none { 
        if runs.last().len() != 0 {
          runs.push(())
        }
        continue 
      }
      filtered-points.push(coord)
      runs.last().push(coord)
    }
    return (filtered-points, runs)
  } else {
    return points.filter(p => p.find(float.is-nan) == none)
  }
}


/// Converts an array of points to a step sequence. 
/// Given $n$ points, the output will have $2n-1$ points and zero points 
/// if the input has zero points. 
///
/// -> array
#let stepify(

  /// Input points of the form `(x, y)` with `float.nan` values removed. 
  /// -> array
  points, 

  /// Step mode
  /// - `start`: The interval $(x_{i-1}, x_i]$ takes the value of $x_i$. 
  /// - `end`: The interval $[x_i, x_{i+1})$ takes the value of $x_i$. 
  /// - `center`: The value switches half-way between consecutive $x$ positions. 
  /// -> start | center | end
  step: start

) = {
  if points.len() == 0 { return () }
  let result = ()
  if step == start {
    for i in range(points.len() - 1) {
      result.push(points.at(i))
      result.push((points.at(i).at(0), points.at(i + 1).at(1)))
    }
  } else if step == end {
    for i in range(points.len() - 1) {
      result.push(points.at(i))
      result.push((points.at(i + 1).at(0), points.at(i).at(1)))
    }
  } else if step == center {
    for i in range(points.len() - 1) {
      result.push(points.at(i))
      let mid = 0.5 * (points.at(i).at(0) + points.at(i + 1).at(0))
      result.push((mid, points.at(i).at(1)))
      result.push((mid, points.at(i + 1).at(1)))
    }
  }
  result.push(points.last())
  return result
}



/// Transforms a generalized point
#let transform-point(x, y, transform) = {
  if type(x) in (int, float) {
    x = transform(x, 1).at(0)
  }
  if type(y) in (int, float) {
    y = transform(1, y).at(1)
  }
  return (x, y)
}
#let convert-bezier-curve(points, transform) = {
  let v = points.at(0)
  let p = transform-point(..v, transform)
  let result = (p,)
  
  for (x, y) in points.slice(1) {
    if type(x) in (int, float) {
      x = transform(x + v.at(0), 1).at(0) - p.at(0)
    }
    if type(y) in (int, float) {
      y = transform(1, y + v.at(1)).at(1) - p.at(1)
    }
    result.push((x, y))
  }
  return result
}

// point and size pt -> makes sense
// point and size data coords -> makes sense
// point data coords and size pt -> makes sense
// point data pt and size data coords -> makes no sense


#let convert-rect(
  x, 
  y, 
  width, 
  height, 
  transform,
  align: top + left
) = {

  // at the end we only want (relative) lengths

  if type(width) in (int, float) {
    assert(type(x) in (int, float), message: "Setting the width in terms of data coordinates is only allowed if the origin x coordinate is given in data coordinates")
    
    if align.x != left {
      if align.x == right { x -= width }
      else if align.x == center { x -= width / 2 }
      align = align.y + left
    }
    width = transform(x + width, 1).at(0) - transform(x, 1).at(0)

  }

  if type(height) in (int, float) {
    assert(type(y) in (int, float), message: "Setting the height in terms of data coordinates is only allowed if the origin y coordinate is given in data coordinates")

    if align.y != top {
      if align.y == bottom { y -= height }
      else if align.y == horizon { y -= height / 2 }
      align = align.x + top
    }
    height = transform(1, y + height).at(1) - transform(1, y).at(1) 
  }

  let (x, y)  = transform-point(x, y, transform)

  if align.x == right { x -= width }
  else if align.x == center { x -= width / 2 }
  
  if align.y == bottom { y -= height }
  else if align.y == horizon { y -= height / 2 }


  return (x, width, y, height)
}

#let is-data-coordinates(coord) = type(coord) in (int, float)
#let all-data-coordinates(coords) = {
  return coords.map(is-data-coordinates).fold(true, (a, b) => a and b)
}


// Convert a vertex for `path`. A vertex may either be a single vertex
// or a pair/triple of vertices describing a point with handles on a
// bezier curve. 
#let convert-vertex(v, transform: it => it) = {
  if type(v.at(0)) == array {
    return v.map(p => transform-point(..p, transform))
  } else {
    transform-point(..v, transform)
  }
}



// Process error inputs of the form as documented in @plot.xerr. 
#let process-errors(err, n /* basically x.len() */, kind: "x") = {

  if type(err) in (int, float) {
    err = (p: (err,) * n, m: (err,) * n)

  } else if type(err) == dictionary {
    assert(
      "m" in err and "p" in err,
      message: "Error bar dictionaries must contain both \"p\" and \"m\""
    )
    if err.keys().len() != 2 {
      let key = err.keys().filter(x => x not in ("m", "p")).first()
      assert(
        false,
        message: "Errorbar dictionary contains unexpected key \"" + key + "\", expected \"p\" and \"m\""
      )
    }

    if type(err.m) in (int, float) {
      err.m = (err.m,) * n
    } else if type(err.m) == array {
      assert(
        err.m.len() == n,
        message: "The length of `" + kind + "err.m` does not match the number of data points"
      )
    } else {
      assert(false, message: "`" + kind + "err.m` expects a float or an array")
    }
    if type(err.p) in (int, float) {
      err.p = (err.p,) * n
    } else if type(err.p) == array {
      assert(
        err.p.len() == n,
        message: "The length of `" + kind + "err.p` does not match the number of data points"
      )
    } else {
      assert(false, message: "`" + kind + "err.p` expects a float or an array")
    }

  } else if type(err) == array {
    assert(
      err.len() == n, 
      message: "The length of `" + kind + "err` (" + str(err.len()) + ") does not match the number of data points"
    )

    err = err.map(e => {
      if type(e) in (int, float) { (p: e, m: e) }
      else if type(e) == dictionary { 
        assert("p" in e and "m" in e, message: "Errorbar dictionaries must contain both \"m\" and \"p\"")
        e
      }
      else { assert(false, message: "Expected a single uncertainty or a dictionary, found " + repr(e))}
    })
    err = (p: err.map(e => e.p), m: err.map(e => e.m))

  } else {
    assert(
      false, 
      message: "`" + kind + "err` expects a float, an array, or a dictionary with the keys \"p\" and \"m\"."
    )

  }
  err
}