#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

#let precipitation = (56, 41, 53, 42, 60, 67, 81, 62, 56, 49, 48, 54)
#let temperature = (0.5, 1.4, 4.4, 9.7, 14.4, 17.8, 19.8, 19.5, 15.5, 10.4, 5.6, 2.2)

#lq.diagram(
  width: 8cm, 
  title: [Climate of Berlin],
  ylabel: [Temperature in °C],
  xlabel: [Month],
  legend: (position: left + top),
  margin: (top: 20%),

  xaxis: (
    ticks: months.map(rotate.with(-90deg, reflow: true)).enumerate(),
    subticks: none
  ),


  lq.yaxis(
    position: right,
    label: [Precipitation in mm],
    lq.bar(
      range(12), precipitation,
      fill: blue.lighten(40%),
      label: [Precipitation]
    ),
  ),
  

  lq.plot(
    range(12), temperature,
    label: [Temperature],
    color: red, stroke: 1pt, mark-size: 6pt,
  )
)