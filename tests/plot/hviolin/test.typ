#import "../template.typ": *
#import "/src/lilaq.typ" as lq


#set page(width: auto, height: auto, margin: 1pt)

#show: minimal





#let data = (
  (2, 1.5, 1, 1, 1, .5, .5, .5, .5, 0, -.5),
  (2, 1.5, 1, 1, 1, .75, .5, .5, .5, 0, -.5),
  (1, 1, 1, 1, .75, .4, .4, .5, 0, -.5),
)


// Automatic x
#lq.diagram(
  lq.hviolin(..data),
)

#pagebreak()


// Manual positions and width
#lq.diagram(
  lq.hviolin(data.at(0), y: (-1), width: .8),
  lq.hviolin(..data.slice(1), y: (1, 2), width: (.5, 1)),
)

#pagebreak()


// Datetime x and ratio/duration width
#lq.diagram(
  lq.hviolin(
    ..data.slice(0, 2),
    y: (
      datetime(year: 2025, month: 2, day: 1),
      datetime(year: 2025, month: 3, day: 1),
    ),
    width: 80%,
  ),
  lq.hviolin(
    data.at(2),
    y: datetime(year: 2025, month: 4, day: 1),
    width: duration(weeks: 4),
  ),
  lq.hviolin(
    ..data.slice(1),
    y: (
      datetime(year: 2025, month: 5, day: 1),
      datetime(year: 2025, month: 6, day: 1),
    ),
    width: (
      duration(weeks: 2),
      duration(weeks: 1),
    ),
  ),
)

#pagebreak()


// Bandwidth, trim, and num-points
#lq.diagram(
  lq.hviolin(..data, bandwidth: .1, trim: false, num-points: 30),
)

#pagebreak()


// Fill and stroke and legend images
#lq.diagram(
  lq.hviolin(data.at(0), fill: yellow, label: []),
  lq.hviolin(data.at(1), y: 2, fill: none, stroke: green, label: []),
  lq.hviolin(data.at(2), y: 3, fill: 10%, stroke: 2pt, label: []),
)

#pagebreak()


// Sides
#lq.diagram(
  width: 2cm,
  lq.hviolin(range(10), side: "low"),
  lq.hviolin(range(10), side: "high"),
)

#pagebreak()


// Sides, inverted axes
#lq.diagram(
  width: 2cm,
  yaxis: (inverted: true),
  lq.hviolin(range(10), side: "low"),
  lq.hviolin(range(10), side: "high"),
)

#pagebreak()


// Median line
#lq.diagram(
  lq.hviolin(data.at(1), median: white + .7pt),
  lq.hviolin(data.at(1), y: 2, median: "s"),
)

#pagebreak()


// Boxplot
// Fill and stroke
#lq.diagram(
  lq.hviolin(data.at(0), boxplot: none),
  lq.hviolin(
    data.at(1),
    y: 2,
    boxplot: (fill: white, stroke: black),
    whisker-pos: 2,
  ),
  lq.hviolin(data.at(2), y: 3),
)

#pagebreak()


// Constant boxplot width
#lq.diagram(
  lq.hviolin(data.at(1), boxplot: (width: 20pt), extrema: true),
  lq.hviolin(
    data.at(1),
    y: 2,
    side: "low",
    boxplot: (width: 5pt),
    extrema: true,
  ),
  lq.hviolin(
    data.at(1),
    y: 2,
    side: "high",
    boxplot: (width: 5pt),
    extrema: true,
  ),
  lq.hviolin(data.at(1), y: 3, width: 1, boxplot: (width: 20pt)),
  lq.hviolin(data.at(1), y: 4, width: .5, boxplot: (width: .5)),
)

#pagebreak()


// Constant boxplot width
#lq.diagram(
  yaxis: (inverted: true),
  lq.hviolin(data.at(1), boxplot: (width: 20pt), extrema: true),
  lq.hviolin(
    data.at(1),
    y: 2,
    side: "low",
    boxplot: (width: 5pt),
    extrema: true,
  ),
  lq.hviolin(
    data.at(1),
    y: 2,
    side: "high",
    boxplot: (width: 5pt),
    extrema: true,
  ),
  lq.hviolin(data.at(1), y: 3, width: 1, boxplot: (width: 20pt)),
  lq.hviolin(data.at(1), y: 4, width: .5, boxplot: (width: .5)),
)

#pagebreak()


// Ratio boxplot width
#lq.diagram(
  yaxis: (inverted: true),
  lq.hviolin(data.at(1), boxplot: (width: 50%)),
  lq.hviolin(data.at(1), y: 2, side: "low", boxplot: (width: 25%)),
  lq.hviolin(data.at(1), y: 2, side: "high", boxplot: (width: 25%)),
  lq.hviolin(data.at(1), y: 3, width: 1, boxplot: (width: 50%), median: white),
)


#pagebreak()

// Test violin boxplot
#[
  #show: lq.set-violin-boxplot(
    fill: red,
    stroke: .5pt + black,
    width: 50%,
  )
  #lq.diagram(
    lq.hviolin(data.at(1)),
    lq.hviolin(data.at(1), y: 2, side: "low", boxplot: (
      width: 25%,
      fill: auto,
      stroke: auto,
    )),
    lq.hviolin(data.at(1), y: 2, side: "high", boxplot: (stroke: white)),
    lq.hviolin(
      data.at(1),
      y: 3,
      width: 1,
      boxplot: (width: 10%),
      median: white,
    ),
  )
]

#pagebreak()


// Extrema styling
#[
  #show: lq.set-violin-extremum(stroke: black, width: 100%)
  #lq.diagram(
    height: 1cm,
    lq.hviolin(data.at(1), extrema: true),
  )
]
