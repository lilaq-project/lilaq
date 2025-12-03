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
  lq.violin(..data),
)

#pagebreak()


// Manual positions and width
#lq.diagram(
  lq.violin(data.at(0), x: (-1), width: .8),
  lq.violin(..data.slice(1), x: (1, 2), width: (.5, 1)),
)

#pagebreak()


// Datetime x and ratio/duration width
#lq.diagram(
  lq.violin(
    ..data.slice(0, 2), 
    x: (
      datetime(year: 2025, month: 2, day: 1),
      datetime(year: 2025, month: 3, day: 1),
    ),
    width: 80%
  ),
  lq.violin(
    data.at(2), 
    x: datetime(year: 2025, month: 4, day: 1),
    width: duration(weeks: 4)
  ),
  lq.violin(
    ..data.slice(1), 
    x: (
      datetime(year: 2025, month: 5, day: 1),
      datetime(year: 2025, month: 6, day: 1),
    ),
    width: (
      duration(weeks: 2),
      duration(weeks: 1),
    )
  ),
)

#pagebreak()


// Bandwidth, trim, and num-points
#lq.diagram(
  lq.violin(..data, bandwidth: .1, trim: false, num-points: 30),
)

#pagebreak()


// Fill and stroke and legend images
#lq.diagram(
  lq.violin(data.at(0), fill: yellow, label: []),
  lq.violin(data.at(1), x: 2, fill: none, stroke: green, label: []),
  lq.violin(data.at(2), x: 3, fill: 10%, stroke: 2pt, label: []),
)

#pagebreak()


// Sides
#lq.diagram(
  width: 2cm,
  lq.violin(range(10), side: "low"),
  lq.violin(range(10), side: "high"),
)

#pagebreak()


// Sides, inverted axes
#lq.diagram(
  width: 2cm,
  xaxis: (inverted: true),
  lq.violin(range(10), side: "low"),
  lq.violin(range(10), side: "high"),
)

#pagebreak()


// Median line
#lq.diagram(
  lq.violin(data.at(1), median: white),
  lq.violin(data.at(1), x: 2, median: "s"),
)

#pagebreak()


// Boxplot
// Fill and stroke
#lq.diagram(
  lq.violin(data.at(0), boxplot: false),
  lq.violin(data.at(1), x: 2, boxplot-fill: white, boxplot-stroke: black, whisker-pos: 2),
  lq.violin(data.at(2), x: 3),
)

#pagebreak()


// Constant boxplot width
#lq.diagram(
  height: 3cm,
  lq.violin(data.at(1), boxplot-width: 20pt),
  lq.violin(data.at(1), x: 2, side: "low", boxplot-width: 10pt),
  lq.violin(data.at(1), x: 2, side: "high", boxplot-width: 10pt),
  lq.violin(data.at(1), x: 3, width: 1, boxplot-width: 20pt),
  lq.violin(data.at(1), x: 4, width: .5, boxplot-width: .5),
)

#pagebreak()


// Ratio boxplot width
#lq.diagram(
  height: 3cm,
  lq.violin(data.at(1), boxplot-width: 50%),
  lq.violin(data.at(1), x: 2, side: "low", boxplot-width: 25%),
  lq.violin(data.at(1), x: 2, side: "high", boxplot-width: 25%),
  lq.violin(data.at(1), x: 3, width: 1, boxplot-width: 50%, median: white),
)
