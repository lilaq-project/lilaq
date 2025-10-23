
/// Transforms two vectors $a, b$ of the same length with a function that 
/// receives pairs $(a_i,b_i)$ for all $i$. 
#let transform(
  /// First vector. 
  /// -> array
  a, 
  /// Second vector. 
  /// -> array
  b, 
  /// The function to apply to each item.
  /// -> function
  mapper
) = array.zip(a, b, exact: true).map(mapper)


/// Pair-wise adds the elements of two vectors of the same length. 
#let add(
  /// First vector. 
  /// -> array
  a, 
  /// Second vector.
  /// -> array
  b
) = transform(a, b, ((x,y)) => x + y)


/// Pair-wise subtracts the elements of two vectors of the same length. 
#let subtract(
  /// First vector. 
  /// -> array
  a, 
  /// Second vector.
  /// -> array
  b
) = transform(a, b, ((x,y)) => x - y)


/// Multiplies all entries of a vector with a scalar. 
#let multiply(
  /// Vector.
  /// -> array
  a, 
  /// Scalar. 
  /// -> int | float
  c
) = a.map(x => x * c)


/// Computes the inner product of two vectors. 
#let inner(
  /// First vector. 
  /// -> array
  a, 
  /// Second vector.
  /// -> array
  b
) = transform(a, b, ((x,y)) => x * y).sum()




#assert.eq(add((1,2,3), (4,5,6)), (5,7,9))
#assert.eq(subtract((1,2,3), (4,5,6)), (-3,-3,-3))
#assert.eq(multiply((1,2,3), 2), (2,4,6))
#assert.eq(inner((1,2,3), (4,5,6)), 32)


/// Applies random offsets to a vector of values. 
#let jitter(

  /// The vector to transform. 
  /// -> array
  a, 

  /// The seed value. 
  /// -> int
  seed: 0,

  /// The amount of jittering to apply. If @vec.jitter.distribution is
  /// `"uniform"`, this measures the bounds for the random offsets; if it is 
  /// set to `normal`, it specifies the standard deviation. 
  /// -> float
  amount: 0.1, 

  /// Which kind of distribution to use. 
  /// -> "uniform" | "normal"
  distribution: "uniform"

) = {
  import "@preview/suiji:0.4.0"

  let rng = suiji.gen-rng(seed)

  if distribution == "uniform" {
    add(a, suiji.uniform(rng, low: -amount, high: amount, size: a.len()).at(1))
  } else if distribution == "normal" {
    add(a, suiji.normal(rng, scale: amount, size: a.len()).at(1))
  }
}
