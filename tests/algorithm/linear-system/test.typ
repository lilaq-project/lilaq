#import "/src/algorithm/linear-system.typ": thomas-algorithm
#import "/src/assertations.typ": approx

#let A = ((2,),)
#let b = (3,)
#let x = thomas-algorithm(A, b)
#assert.eq(x, (1.5,))

#let A = ((3, 2, 0), (2, 4, 2), (0, 2, 5))
#let b = (1, 0, 3)
#let x = thomas-algorithm(A, b)
#approx(x, (1, -1, 1))

#let A = ((0,) * 5,) * 5
#for i in range(0, 5) {
  A.at(i).at(i) = 1
}
#let b = (1, 42, 17, -5, 0.1)
#let x = thomas-algorithm(A, b)
#approx(x, b)
