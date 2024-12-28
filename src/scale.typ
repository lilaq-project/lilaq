#import "math.typ": sign


/// Constructor for the scale type. Scales are used to transform data coordinates 
/// into scaled coordinates. Commonly, data is displayed with a linear scale, i.e., 
/// the entire data is just scaled uniformly. However, in order to visualize large 
/// ranges, it is often desirable to use logarithmic scaling or other scales that 
/// improve the readability of the data. 
#let scale(

  /// Transformation from data coordinates to scaled coordinates.  
  /// Note that the transformation function does not need to worry about absolute 
  /// scaling and offset. As an example, the transformation function for the linear 
  /// scale is just `x => x` and not `x => a * x + b` or similar and the logarithmic 
  /// scale uses `x => calc.log(x)`. 
  /// -> function
  transform,

  /// A precise inverse of the `transform` should be given here to enable the 
  /// conversion of scaled coordinates back to data coordinates. 
  /// -> function
  inverse,
  
  /// Name of the scale. Built-in scales are sometimes identified by their name, 
  /// e.g., when a suitable tick locator needs to be selected automatically. 
  /// -> str
  name: "",

  ..args
  
) = (
  transform: transform,
  inverse: inverse,
  name: name,
  ..args.named()
)


/// Creates a new linear scale. 
#let linear() = scale(
  name: "linear",
  x => x,
  x => x,
)


/// Creates a new logarithmic scale. 
#let log(
  
  /// -> float
  base: 10
  
) = scale(
  name: "log",
  x => calc.log(x),
  x => calc.pow(10., x),
  base: base,
)


/// Creates a new symlog scale with a linear scaling in the region 
/// `[threshold, threshold]` around 0 and a logarithmic scaling beyond that. 
#let symlog(
  
  /// Base for logarithm. 
  /// -> float
  base: 10, 

  /// Threshold for the linear region
  /// -> float
  threshold: 2, 

  /// Scaling for the linear region
  /// -> float
  linscale: 1
  
) = {
  let c = linscale / (1. - 1. / base)
  let log-base = calc.ln(base)
  let transform = x => {
      if x == 0 { return 0. }
      let abs = calc.abs(x)
      if abs <= threshold { return x * c }
      return sign(x) * threshold * (c + calc.ln(abs / threshold) / log-base)
    }
  let inv-threshold = transform(threshold)
  scale(
    name: "symlog",
    transform,
    x => {
      if x == 0 { return 0. }
      let abs = calc.abs(x)
      if abs <= inv-threshold { return x / c }
      return sign(x) * threshold * calc.pow(base, abs / threshold - c)
    },
    
    threshold: threshold,
    base: base,
    linscale: linscale,
  )
}

#let check-sym(x) = {
  let sym = symlog()
  assert((sym.inverse)((sym.transform)(x)) - x < 1e-15)
}
#check-sym(0)
#check-sym(1)
#check-sym(1.5)
#check-sym(2)
#check-sym(3)




#let scales = (
  linear: linear(),
  log: log(base: 10),
  symlog: symlog(base: 10),
)


/// Creates a data->display transformation that maps the interval 
/// $[x_0, x_1]$ to $[y_0, y_1]$ given some monotonous transformation function 
/// (e.g., identity or log(x)). 
/// 
/// -> function
#let create-trafo(
  
  /// Transformation function that takes one argument. 
  /// -> function
  transform, 
  
  /// Lower interval bound. 
  /// -> float
  x0, 
  
  /// Upper interval bound. 
  /// -> float
  x1, 

  /// Lower target interval bound. 
  /// -> float
  y0: 0, 
  
  /// Upper target interval bound. 
  /// -> float
  y1: 1
  
) = {
  let a = (y1 - y0) / (transform(x1) - transform(x0))
  let b = -a * transform(x0) + y0
  x => a * transform(x) + b
}

#assert.eq(create-trafo(x => x, -23, 4)(-23), 0)
#assert.eq(create-trafo(x => x, -23, 4)(4), 1)

#assert.eq(create-trafo(x => x, -23, 4, y0: 1, y1: -1)(-23), 1)
#assert.eq(create-trafo(x => x, -23, 4, y0: 1, y1: -1)(4), -1)

#assert.eq(create-trafo(x => calc.log(x), 2, 4)(2), 0)
#assert.eq(create-trafo(x => calc.log(x), 2, 4)(4), 1)



// #import "ticking.typ": get-best-step

// #let ticks-linear-base(
//   x0, 
//   x1, 
//   styles, 
//   axis-length,
//   num-ticks-suggestion
// ) = {
//   let Dx = x1 - x0
//   let d = Dx / num-ticks-suggestion
//   let (a, n) = decompose-floating-point(d)
//   let b = get-best-step(a/10)

//   let dt = b * calc.pow(10., n) // tick distance
//   let first-tick = dt * calc.ceil(x0 / dt)
//   let last-tick = dt * calc.floor(x1 / dt)
//   let estimated-num-ticks = Dx / dt // may be one higher
//   let num-ticks = calc.floor((x1 - first-tick) / dt) + 1
//   return range(num-ticks).map(x => first-tick + x * dt)
// }

// #let ticksate-axis-linear(
//   x0, 
//   x1, 
//   styles, 
//   axis-length,
//   num-ticks-suggestion
// ) = {
//   let Dx = x1 - x0
//   // if Dx 
//   let d = Dx / num-ticks-suggestion
//   let (a, n) = decompose-floating-point(d)
//   let b = get-best-step(a)

//   let dt = b * calc.pow(10., n) // tick distance
//   let first-tick = dt * calc.ceil(x0 / dt)
//   let last-tick = dt * calc.floor(x1 / dt)
//   let estimated-num-ticks = Dx / dt // may be one higher
//   let num-ticks = calc.floor((x1 - first-tick) / dt) + 1

//   (
//     ticks-linear-base(x0, x1, styles, axis-length, num-ticks-suggestion),
//     ()
//   )
// }

// #let ticksate-axis-log(
//   x0, 
//   x1, 
//   styles, 
//   axis-length,
//   num-ticks-suggestion,
//   base: 10
// ) = {
//   if x0 > x1 { (x0 ,x1) = (x1, x0) }
//   let log = calc.log.with(base: base)
//   let Dx = x1 - x0
//   let g = log(x1) - log(x0)
//   if g < 2 { return ticksate-axis-linear(x0, x1, styles, axis-length, num-ticks-suggestion) }
  
//   let n0 = calc.ceil(log(x0))
//   let n1 = calc.floor(log(x1))
//   let minor-ticks = ()
//   for i in range(n0 - 1, n1 + 1) {
//     for j in range(1, 9) {
//       let k = (1 + j) * calc.pow(base * 1., i)
//       if k > x0 and k < x1 { minor-ticks.push(k) }
//     }
//   }
//   (
//     range(n0, n1 + 1).map(x => calc.pow(base* 1., x)),
//     minor-ticks
//   )
// }
