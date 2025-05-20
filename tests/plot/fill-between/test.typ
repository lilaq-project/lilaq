#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal



#lq.diagram(
  lq.fill-between(
    range(4),
    (1, 2, 3, 4)
  ),
  lq.fill-between(
    range(4),
    (0.9, 1.8, 2.1, 4),
    y2: (0, 1, -1.2, 0.5),
  )
)



#pagebreak()



#let fill-between = lq.fill-between.with(label: [])
#show lq.selector(lq.legend): set table(columns: 4)

// Cycling test
#lq.diagram(
  cycle: (
    it => { set lq.style(fill: blue); it },
    it => { set lq.style(fill: red); it },
    it => { 
      set lq.style(fill: purple, stroke: green) 
      it
    },
  ),
  fill-between((1, 2, 3), (6,)*3),
  fill-between((1, 2, 3), (5,)*3),
  fill-between((1, 2, 3), (4,)*3, stroke: auto),
  fill-between((1, 2, 3), (3,)*3, fill: green),
  fill-between((1, 2, 3), (2,)*3, stroke: orange),
  fill-between((1, 2, 3), (1,)*3, fill: blue, stroke: aqua),
)



#pagebreak()


// Step
#lq.diagram(
  lq.fill-between(
    (1, 2, 3), (2.1, 2.4, 2.1),
    step: start
  ),
  lq.fill-between(
    (1, 2, 3), (1.1, 1.4, 1.1),
    step: center
  ),
  lq.fill-between(
    (1, 2, 3), (.1, .4, .1),
    step: end
  ),
)




#pagebreak()


// Z-index
#lq.diagram(
  height: 1cm,
  lq.fill-between((0, 1, 2), (0, 1, 2)),
  lq.fill-between((0, 1, 2), (2, 1, 0), z-index: 1),
)


#pagebreak()

// Interrupt at nan
#lq.diagram(
  lq.fill-between(
    range(8),
    (1,2,3,float.nan, 6, 4, float.nan, 3)
  )
)