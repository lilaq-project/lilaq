#import "/lilaq/src/logic/tick-format.typ": *
#import "/lilaq/src/model/axis.typ": draw-axis, _axis-compute-limits, yaxis
#import "../src/logic/scale.typ": *
#import "../src/logic/transform.typ": create-trafo

#set text(size: 8pt)




#let test-axis(
  x0, x1, axis, exponent: auto, offset: auto
) = context {
  let length = 4cm
  let axis = axis
  if type(axis) == dictionary{
    axis = yaxis(lim: (x0, x1), ..axis)
    axis.lim = _axis-compute-limits(axis, lower-margin: 0pt, upper-margin: 0pt)
    
    let normalized-y-trafo = create-trafo(axis.scale.transform, ..axis.lim)
  
    axis.normalized-scale-trafo = normalized-y-trafo
    axis.transform = y => length * (1 - normalized-y-trafo(y))
  }
  axis.lim = (x0, x1)
  let tick-info = locate-ticks-linear(x0, x1, num-ticks-suggestion: 6)
  let ticks = tick-info.ticks
  let minor-ticks = locate-subticks-linear(x0, x1, ..tick-info)
  
  let (tick-labels, exp, offset) = format-ticks-linear(tick-info, exponent: exponent, offset: offset)



  let trafo = create-trafo(axis.scale.transform, x0, x1)
  
  let transform(x, y) = (
    trafo(x) * length, 
    length * (1 - trafo(y))
  )
  
  let axis-style = (
    inset: 5pt,
    outset: 0pt,
    type: "major"
  )
  let ticking = (
    ticks: ticks, tick-labels: tick-labels, subticks: minor-ticks, subtick-labels: none, exp: exp, offset: offset
  )
  let (content, bounds) = draw-axis(
    axis, 
    ticking, 
    axis-style, 
  )
  let max = -bounds.at(0).left
  box(
    inset: 10pt, 
    fill: red.lighten(90%),
    box(
      place(dx: .9*max, content), 
      height: length, width: max,
    )
  )
}


#let ax = (kind: "y", mirror: none)

#test-axis(-200, -199 , ax)
#test-axis(100005, 100006, ax)
#test-axis(115, 116, ax)
#test-axis(-4.2, 20, ax)
#test-axis(-0.000000000000003, 0.0005, ax)
#test-axis(-1, 0, ax)
#test-axis(0.0, 1, ax)
#test-axis(0.0, 0.1, ax)
#test-axis(1.25, 0.1, ax)
#test-axis(0.1, 1.2, ax)
#test-axis(1.2, 0.1, ax)
#test-axis(0.1, 1.2, ax)


Test inverse axes

#test-axis(0.1, 1.2, ax)
#test-axis(1.25, 0.1, ax)
#test-axis(1, 0, ax)
#test-axis(1.2, 0.1, ax)
#test-axis(0.1, 1.2, ax)

Test negative axes

#test-axis(-2.2, 20, ax)
#test-axis(-4.2, -2, ax)
#test-axis(-4.2, 8.1, ax)
#test-axis(-116, -115, ax)
#test-axis(-16, -15, ax)
#test-axis(-0.0000000000000003, 0.0005, ax)

Exponent modes (`auto`, `"inline"`, `0`, `4`, `4`, `"inline"`):

#test-axis(0, 2e9, ax, exponent: auto)
#test-axis(0, 2e9, ax, exponent: "inline")
#test-axis(0, 2e9, ax, exponent: 0)
#test-axis(0, 2e9, ax, exponent: 4)
#test-axis(0, 2e-4, ax, exponent: 4)
#test-axis(0, 2e-4, ax, exponent: "inline")

Offset modes (`auto`, `0`, `9999`, `10002`):

#test-axis(10000, 10001, ax, offset: auto)
#test-axis(10000, 10001, ax, offset: 0)
#test-axis(10000, 10001, ax, offset: 9999)
#test-axis(10000, 10001, ax, offset: 10002)


Test auto offset

#test-axis(10015, 10016, ax)
#test-axis(10015, 10019, ax)
#test-axis(999, 1000, ax)
#test-axis(1000, 1001, ax)
#test-axis(19999, 20000, ax)
#test-axis(-20000, -19999, ax)
#test-axis(34001, 34002, ax)
#test-axis(34000, 34015, ax)
#test-axis(1, 2, ax)
#test-axis(1, 200, ax)
#test-axis(34000, 2000000000000, ax)
#test-axis(0.0000000000000003, 0.0005, ax)

Test auto exponent

#test-axis(0, 10000, ax)
#test-axis(0, 1000, ax)
#test-axis(0, 100, ax)
#test-axis(0, 10, ax)
#test-axis(0, 1, ax)
#test-axis(0, .1, ax)
#test-axis(0, .01, ax)
#test-axis(0, .001, ax)
#test-axis(0, .0001, ax)
#test-axis(0, 1e-20, ax)

#assert.eq(discretize-up(1.2, 2, -1), 1.2)
#assert.eq(discretize-down(1.2, 2, -1), 1.2)
#assert.eq(discretize-up(0.1, 2, -2), 0.1)
#assert.eq(discretize-down(1.2, 2, -10), 1.2)
#assert.eq(discretize-down(0.23456789, 5, -8), 0.23456785)
#assert.eq(discretize-up(0.23456789, 5, -8), 0.2345679)
#assert.eq(discretize-down(2345.23, 2, -2), 2345.22)
#assert.eq(discretize-down(2345.23, 2, -1), 2345.2)
#assert.eq(discretize-down(2345.23, 2, 0), 2344)
#assert.eq(discretize-down(2345.23, 2, 1), 2340)
#assert.eq(discretize-down(2345.23, 2, 2), 2200)
#assert.eq(discretize-down(2345.23, 2, 3), 2000)
#assert.eq(discretize-up(2345.23, 2, 1), 2360)
#assert.eq(discretize-up(2345.23, 2, 0), 2346)
#assert.eq(0.2, 0.4/2)
#assert.eq(discretize-down(34, 5, 0), 30)
#assert.eq(discretize-down(1015, 11, 0), 1012)
#assert.eq(discretize-down(10153823420, 1000, 0), 10153823000)

#assert.eq(discretize-up(34, 5, 0), 35)
#assert.eq(discretize-up(1015, 11, 0), 1023)
#assert.eq(discretize-up(10153823420, 1000, 0), 10153824000)

