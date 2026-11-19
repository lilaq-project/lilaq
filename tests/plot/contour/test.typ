#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal


// Stroked

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    levels: 7,
  ),
)


#pagebreak()



// Filled

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    fill: true,
    levels: 7,
  ),
)


#pagebreak()

// Styling, norm and min/max

#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    levels: 7,
    stroke: (dash: "dashed", thickness: .5pt),
    map: color.map.turbo,
    norm: "symlog",
    min: -3,
    max: 3,
  ),
)


#pagebreak()



// Inverted axes

#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => y * x - x * x - x,
    fill: true,
    levels: 7,
  ),
)


#pagebreak()



// Matplotlib contour plot example

#{
  let x = lq.linspace(-3, 3, num: 40)
  let y = lq.linspace(-3, 3, num: 40)
  let z = lq.mesh(x, y, (x, y) => (
    (1 - x / 2 + calc.pow(x, 5) + calc.pow(y, 3)) * calc.exp(-x * x - y * y)
  ))
  let (zmin, zmax) = lq.minmax(z.flatten())
  lq.diagram(
    lq.contour(
      x,
      y,
      z,
      fill: true,
      levels: lq.linspace(zmin, zmax, num: 7),
    ),
  )
}


// level behaviour with min/max
#pagebreak()

#{
  let F = 1000 // N
  let l = 1100 // mm
  let S = 1.34

  let (b, h) = (30, lq.linspace(40, 115, num: 30))
  let ws = lq.linspace(1, 9, num: 30)

  let Mb = F * l

  let I(b, h, ws) = {
    b * calc.pow(h, 3) / 12 - (b - 2 * ws) * calc.pow(h - 2 * ws, 3) / 12
  }
  let sigma(ws, h) = {
    Mb / I(b, h, ws) * h / 2 * S
  }

  lq.diagram(
    lq.contour(
      ws,
      h,
      sigma,
      fill: true,
      levels: 10,
      min: 0,
      max: 1000,
    ),
    // There should be a step visible below the dotted line
    lq.contour(
      ws,
      h,
      sigma,
      fill: false,
      levels: (100,),
      stroke: (paint: black, thickness: 0.7pt, dash: "dotted"),
    ),
  )
}


#pagebreak()

// Filled with tilings
#let fill = (
  lq.tilings.diag(),
  lq.tilings.diag(angle: 0deg),
  lq.tilings.diag(angle: -45deg),
  lq.tilings.diag(angle: 90deg),
)
#lq.diagram(
  let contour = lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    fill: fill,
    map: (white, luma(40%)),
    levels: (-4, -1, 0, 2, 3),
  ),
  contour,
)
#lq.colorbar(contour)


#pagebreak()

#lq.diagram(
  let contour = lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    stroke: (
      (dash: "dashed"),
      (dash: "dash-dotted"),
      (dash: "solid", thickness: 2pt),
    ),
    levels: 7,
  ),
  contour,
)
#lq.colorbar(contour)

#pagebreak()


#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => x * y,
    stroke: level => if level < 0 { (dash: "dashed") } else { (dash: "solid") },
    levels: 7,
  ),
)



#pagebreak()



#lq.diagram(
  lq.contour(
    lq.linspace(-1, 3),
    lq.linspace(-2, 2),
    (x, y) => (
      2
        * (
          calc.exp(-x * x - y * (y + 1))
            - calc.exp(-calc.pow(x - 3, 2) - calc.pow(y - 1, 2))
        )
    ),
    level-labels: auto,
  ),
)


#pagebreak()

// Level labels
#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 10),
    lq.linspace(-2, 2, num: 10),
    (x, y) => x * y,
    levels: 7,
    level-labels: (all: true),
  ),
)

#pagebreak()

// Level labels with custom stroke color
#lq.diagram(
  let c = lq.contour(
    lq.linspace(-1.5, 1.5, num: 50),
    lq.linspace(-1.5, 1.5, num: 50),
    (x, y) => calc.exp(-x * x - y * y) - .5,
    stroke: level => if level < 0 { (paint: red, dash: "dashed") } else {
      (paint: black, dash: "solid")
    },
    level-labels: auto,
  ),
  c,
)
#lq.colorbar(c)

#pagebreak()

// dense labels and styling
#[
  #show lq.selector(lq.contour-level-label): set text(.8em)
  #show lq.selector(lq.contour-level-label): set pad(0em)
  #lq.diagram(
    lq.contour(
      lq.linspace(-2, 2, num: 16),
      lq.linspace(-2, 2, num: 16),
      (x, y) => x * y,
      levels: 50,
      level-labels: auto,
    ),
  )
]
#pagebreak()

// Level label position correctness
#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.contour(
    lq.linspace(-2, 2, num: 6),
    lq.linspace(-2, 2, num: 6),
    (x, y) => (x + 1) * (y - 1),
    levels: 7,
    level-labels: auto,
  ),
)

#pagebreak()

// Manual level labels
#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 10),
    lq.linspace(-2, 2, num: 10),
    (x, y) => x * y,
    levels: 10,
    level-labels: (
      positions: (
        (1.5, 1.5),
        (0, 1),
        (0, -1),
        (1, 0),
        (-1.5, -1.5),
        (-1.4, 1.6),
      ),
    ),
  ),
)

#pagebreak()


// axis inversion
#lq.diagram(
  xaxis: (inverted: true),
  yaxis: (inverted: true),
  lq.contour(
    lq.linspace(-2, 2, num: 23),
    lq.linspace(-3, 3, num: 21),
    (x, y) => calc.sin(x) * (y - 1) + calc.tanh(y),
    levels: 7,
    level-labels: auto,
  ),
)


#pagebreak()

// custom formatter
#lq.diagram(
  lq.contour(
    lq.linspace(-2, 2, num: 10),
    lq.linspace(-2, 2, num: 10),
    (x, y) => x * y,
    levels: 10,
    level-labels: (
      format: levels => levels.map(level => "Level " + str(level)),
    ),
  ),
)
