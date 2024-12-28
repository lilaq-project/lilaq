#import "math.typ" as pmath
#import "plot-utils.typ": *

/// Takes an array of points as input and filters all points where at least one
/// coordinate is #calc.nan to produce
/// + a filtered copy of the input array
/// + an array of consecutive "runs", i.e., all connected sequences from the input
///   separated by points where one or more coordinates take the value #calc.nan. 
///
/// - points (array): Input points. The points themselves may have any dimension.
#let filter-nan-points(points, generate-runs: false) = {
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
/// - points (array): Input points of the form (x, y) with NaNs removed. 
/// - step (string): Step mode (`start`, `end`, or `center`). 
///          - `start`: The interval $(x_(i-1), x_i]$ takes the value of $x_i$. 
///          - `end`: The interval $[x_i, x_(i+1))$ takes the value of $x_i$. 
///          - `center`: The value switches half-way between consecutive $x$ positions. 
/// -> array
#let stepify(points, step: start) = {
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

#assert.eq(stepify((), step: start), ())
#assert.eq(stepify(((0,0),), step: start), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: start), ((0,0), (0,.7), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: start), ((0,0), (0,.7), (1,.7), (1,-.1), (3,-.1)))

#assert.eq(stepify((), step: end), ())
#assert.eq(stepify(((0,0),), step: end), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: end), ((0,0), (1,0), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: end), ((0,0), (1,0), (1,.7), (3, .7), (3,-.1)))

#assert.eq(stepify((), step: center), ())
#assert.eq(stepify(((0,0),), step: center), ((0,0),))
#assert.eq(stepify(((0,0), (1,.7)), step: center), ((0,0), (0.5,0), (0.5, .7), (1,.7)))
#assert.eq(stepify(((0,0), (1,.7), (3,-.1)), step: center), ((0,0), (.5,0), (.5, .7), (1,.7), (2, .7), (2, -.1), (3,-.1)))


