#set page(width: auto, height: auto, margin: 1pt)

#import "../template.typ": *
#show: minimal



#lq.diagram(
  // yaxis: (inverted: true),
  lq.hboxplot(
    (0, 1, 2, 3),
    (0, 4, 5, 6),
    (-1, 0, 9, 10),
  ),
)


#pagebreak()



// Dictionary input

#lq.diagram(
  lq.hboxplot(
    range(4),
    (
      median: 2.5,
      q1: 1, 
      q3: 3, 
      whisker-low: 0, 
      whisker-high: 10, 
    ),
    (
      median: 7,
      q1: 3, 
      q3: 8, 
      whisker-low: 2, 
      whisker-high: 10, 
      outliers: (0, 1)
    ),
    y: (1, 2, 4)
  )
)


#pagebreak()



// Styling

#lq.diagram(
  ylim: (0, 2),
  lq.hboxplot(
    (0, 1, 2, 2, 2, 3) + (6,),
    width: 1,
    fill: blue,
    stroke: aqua,
    median: 2pt + green,
    whisker: red,
    cap: yellow,
    cap-length: 1,
    outliers: "s",
    outlier-size: 2pt,
    outlier-fill: green,
    outlier-stroke: .5pt + black
  )
)


#pagebreak()



// Mean

#lq.diagram(
  lq.hboxplot(
    (1, 2, 3, 7, 8),
    mean: "x"
  ),
  lq.hboxplot(
    (1, 2, 3, 7, 8),
    mean: green + 1pt,
    y: 2
  )
)


#pagebreak()



// Whisker position

#lq.diagram(
  lq.hboxplot(
    (1, 3, 4, 5, 6, 3, 1, 72, 3, 7, 8, 10,11, 34),
    whisker-pos: 6,
  )
)

#pagebreak()


// Inverted axes

#lq.diagram(
  yaxis: (inverted: true),
  xaxis: (inverted: true),
  lq.hboxplot(
    (0, 1, 2, 3),
    (0, 4, 5, 6),
    (-1, 0, 9, 10),
  ),
)