/// A module containing helper functions for vector operations. 


/// Transforms two vectors $vec(a),vec(b)$ of same length with a function that 
/// receives pairs $(a_i,b_i)$ for all $i$. 
#let transform(
  /// First vector. 
  a, 
  /// Second vector. 
  b, 
  /// The function to apply to each item.
  mapper
) = array.zip(a, b, exact: true).map(mapper)


/// Pair-wise adds the elements of two vectors of same length. 
#let add(
  /// First vector. 
  a, 
  /// Second vector.
  b
) = transform(a, b, ((x,y)) => x + y)


/// Pair-wise subtracts the elements of two vectors of same length. 
#let subtract(
  /// First vector. 
  a, 
  /// Second vector.
  b
) = transform(a, b, ((x,y)) => x - y)


/// Multiplies all entries of a vector with a scalar. 
#let multiply(
  /// Vector.
  a, 
  /// Scalar. 
  c
) = a.map(x => x * c)


/// Computes the inner product of two vectors. 
#let inner(
  /// First vector. 
  a, 
  /// Second vector.
  b
) = transform(a, b, ((x,y)) => x * y).sum()




#assert.eq(add((1,2,3), (4,5,6)), (5,7,9))
#assert.eq(subtract((1,2,3), (4,5,6)), (-3,-3,-3))
#assert.eq(multiply((1,2,3), 2), (2,4,6))
#assert.eq(inner((1,2,3), (4,5,6)), 32)
