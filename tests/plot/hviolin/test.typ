#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal



#lq.diagram(
  lq.hviolin(
    (0, 1, 2, 3, 2, 2.5, 1.5),
    (0, 4, 5, 6, 5, 5.5, 4.5),
    (-1, 0, 9, 10, 8, 9, 9.5),
  ),
)

// Styling

#lq.diagram(
  ylim: (0, 2),
  lq.hviolin(
    (0, 1, 2, 2, 2, 3) + (6,),
    width: 1,
    fill: blue.lighten(60%),
    stroke: aqua.darken(30%),
  )
)


#pagebreak()



// Mean marker

#lq.diagram(
  lq.hviolin(
    (1, 2, 3, 7, 8, 5, 4, 6),
    mean: "x",
  ),
  lq.hviolin(
    (1, 2, 3, 7, 8, 5, 4, 6),
    mean: "o",
    mean-fill: red,
    y: 2
  )
)


#pagebreak()



// Custom positions

#lq.diagram(
  lq.hviolin(
    range(4),
    range(10, 20),
    range(5, 15),
    y: (1, 3, 5)
  )
)
