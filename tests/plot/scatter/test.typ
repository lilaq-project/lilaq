#set page(width: auto, height: auto, margin: 1pt)
#import "/src/lilaq.typ" as lq

#let scatter = lq.scatter.with(size: (300,), label: [])

#show: lq.set-diagram(
  height: 2cm,
  width: 3cm,
  xaxis: none,
  yaxis: none,
  grid: none,
  legend: (position: left, dx: 100%),
)


#show lq.selector(lq.legend): set table(inset: 0pt)






#let scatter = lq.scatter.with(size: 10pt, label: [])

// Color
#lq.diagram(
  // Manual color
  scatter(
    range(4), (4,) * 4, 
    color: (red, blue, yellow, orange),
  ),
  // Scalar-based color
  scatter(
    range(4), (3,) * 4, 
    color: range(4),
  ),
  // Same with different map
  scatter(
    range(4), (2,) * 4, 
    color: range(4),
    map: color.map.cividis
  ),
  // Manual max/min
  scatter(
    range(4), (1,) * 4, 
    color: range(4),
    max: 2,
    min: 1,
  ),
  // Manual max/min
  scatter(
    range(4), (0,) * 4, 
    color: range(1, 5),
    norm: "log"
  )
)

#pagebreak()


// Mark
#lq.diagram(
  height: 1cm,
  cycle: (
    (mark: "+"),
    (mark: "x"),
  ),
  lq.scatter((0,), (0,)),
  lq.scatter((1,), (0,)),
  lq.scatter((2,), (0,), mark: "s"),
  lq.scatter((3,), (0,), mark: lq.marks.at("*")),
)


#pagebreak()


// Test interaction between various fill and stroke settings
#lq.diagram(
  ylim: (-.5, 1.5),
  xlim: (-.5, 3.5),
  cycle: (
    it => { set lq.style(fill: blue); it },
    it => { set lq.style(fill: gray); set lq.mark(fill: yellow, stroke: red); it},
  ),
  // Plain scatter. Color for fill and stroke is inherited from the cycle
  scatter((0,), (1,)),
  // Same but now the cycle specifies special mark.fill and mark.stroke
  scatter((1,), (1,)),
  // The cycle color is overridden through the scatter interface
  scatter((2,), (1,), color: green),
  // Same but the mark.stroke from the cycle is not overriden
  scatter((3,), (1,), color: green),
  // Color-coded scatter
  scatter((0,), (0,), color: (4,)),
  // Color-coded scatter and explit `stroke: none`
  scatter(
    (1,), (0,), color: (4,), 
    stroke: none
  ),
  // The stroke is set through the scatter interface
  scatter(
    (2,), (0,), color: (4,), 
    stroke: (dash: "dotted", thickness: 2pt)
  ),
  // The stroke set via the scatter interface is merged with the
  // mark.stroke from the cycle. 
  scatter(
    (3,), (0,), color: (4,), 
    stroke: (dash: "dotted", thickness: 2pt)
  ),
)


#pagebreak()


// Size
#lq.diagram(
  // Single absolute size
  lq.scatter((0, 1, 2), (2,) * 3, size: 10pt, label: []),
  // Per-point absolute size
  lq.scatter((0, 1, 2), (1,) * 3, size: (5pt, 10pt, 20pt), label: []),
  // Per-point area-proportional size
  lq.scatter((0, 1, 2), (0,) * 3, size: (5, 10, 20), label: []),
)


#pagebreak()


// Alpha
#lq.diagram(
  // Single absolute alpha
  lq.scatter(
    (0, 1, 2), (2,) * 3, size: 10pt, 
    color: blue, alpha: 50%, 
    label: []
  ),
  // Per-point alpha
  lq.scatter(
    (0, 1, 2), (1,) * 3, size: 10pt, 
    color: blue, alpha: (50%, 10%, 100%), 
    label: []
  ),
  // Color-coding and per-point alpha
  lq.scatter(
    (0, 1, 2), (0,) * 3, size: 10pt, 
    alpha: (50%, 50%, 50%), 
    color: (1,2,3),
    label: []
  ),
)
// alpha together with `scatter.color: auto` (i.e., color is inherited
// from the cycle) does not work currently. And I think that's okay. 

