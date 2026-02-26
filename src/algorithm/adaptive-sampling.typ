// Cosine similarity between two 2D vectors.
#let _vec-cos((x1, y1), (x2, y2)) = {
  let dot = x1 * x2 + y1 * y2
  let mag = calc.sqrt(x1 * x1 + y1 * y1) * calc.sqrt(x2 * x2 + y2 * y2)
  if mag == 0 { return 1.0 }
  dot / mag
}

// Vertical distance of point (xm, ym) from line through (x1,y1)-(x2,y2).
#let _lin-error((x1, y1), (x2, y2), (xm, ym)) = {
  let dx = x2 - x1
  if dx == 0 { return calc.abs(xm - x1) }
  calc.abs(y1 + (xm - x1) * (y2 - y1) / dx - ym)
}

/// Adaptively samples a function using display-space error metrics.
///
/// Subdivides intervals where the curve shows significant curvature or
/// deviation from linear interpolation in display (post-transform) coordinates.
///
/// - fn: data-space function `x -> y`
/// - transform: `(x, y) -> (display-x, display-y)` coordinate transform
/// - pts: sorted array of initial grid points
/// - cos-tol: cosine tolerance for angle at midpoints (smaller = stricter)
/// - err-tol: max linear interpolation error in display points (pt)
/// - max-depth: maximum subdivision depth per interval
///
/// Returns an array of `(x, y)` data-space coordinate pairs.
#let adaptive-sample(fn, transform, pts, cos-tol: none, err-tol: none, max-depth: none) = {
  let subdivide(x1, x2, dx1, dy1, dx2, dy2, depth) = {
    let xm = (x1 + x2) / 2
    let ym = fn(xm)

    let (dxm, dym) = transform(xm, ym).map(it => it.pt())

    let cos-err = 1 + _vec-cos((dx2 - dxm, dy2 - dym), (dx1 - dxm, dy1 - dym))
    let y-err = _lin-error((dx1, dy1), (dx2, dy2), (dxm, dym))

    if (y-err > err-tol or cos-err > cos-tol) and depth < max-depth {
      subdivide(x1, xm, dx1, dy1, dxm, dym, depth + 1) + subdivide(xm, x2, dxm, dym, dx2, dy2, depth + 1)
    } else {
      ((dx2 * 1pt, dy2 * 1pt),)
    }
  }

  if pts.len() < 2 { return pts.map(p => transform(..p)).map(it => it.pt()) }

  let last-d-pt = transform(..pts.first()).map(it => it.pt())
  let result = (last-d-pt.map(it => it * 1pt),)

  for i in range(0, pts.len() - 1) {
    let p1 = pts.at(i)
    let p2 = pts.at(i + 1)

    let (dx1, dy1) = last-d-pt
    let (dx2, dy2) = transform(..p2).map(it => it.pt())

    result += subdivide(p1.at(0), p2.at(0), dx1, dy1, dx2, dy2, 0)

    last-d-pt = (dx2, dy2)
  }
  result
}
