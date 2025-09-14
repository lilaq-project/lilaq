#set page(width: auto, height: auto, margin: 10pt)
#import "/src/lilaq.typ" as lq


#show: lq.set-diagram(
  height: 10pt,
  yaxis: none,
  grid: none,
  xaxis: (mirror: none)
)

#lq.diagram(
  // title: [Years],
  lq.plot(
    (
      datetime(year: 2021, month: 7, day: 27),
      datetime(year: 2030, month: 8, day: 4)
    ),
    (1, 2)
  )
)


#pagebreak()

#lq.diagram(
  // title: [Months, single year],
  lq.plot(
    (
    datetime(year: 2011, month: 2, day: 1),
    datetime(year: 2011, month: 7, day: 4)
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Months, cross-year],
  lq.plot(
    (
      datetime(year: 2010, month: 6, day: 1),
      datetime(year: 2011, month: 7, day: 4)
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Months, start of the year],
  // xaxis: (offset: none),
  lq.plot(
    (
      datetime(year: 2011, month: 1, day: 1),
      datetime(year: 2011, month: 7, day: 4)
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Months, inverted],
  xaxis: (inverted: true),
  lq.plot(
    (
      datetime(year: 2011, month: 1, day: 1),
      datetime(year: 2012, month: 2, day: 4)
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Months manual],
  xaxis: (locate-ticks: lq.tick-locate.months.with(steps: (6,))),
  lq.plot(
    (
      datetime(year: 2021, month: 12, day: 27),
      datetime(year: 2024, month: 1, day: 27),
    ),
    (1, 2)
  )
)


#pagebreak()



#lq.diagram(
  // title: [Days, single month],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 3),
      datetime(year: 2023, month: 1, day: 8),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Days, cross-month],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1),
      datetime(year: 2023, month: 2, day: 4),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Days, start of the month],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1),
      datetime(year: 2023, month: 1, day: 8),
    ),
    (1, 2)
  )
)

#{
  show: lq.tick-format.set-datetime-smart-format(
    smart-first: false
  )
  lq.diagram(
    // title: [Days, start of the month \ `smart-first: false`],
    lq.plot(
      (
        datetime(year: 2023, month: 1, day: 1),
        datetime(year: 2023, month: 1, day: 8),
      ),
      (1, 2)
    )
  )
}

#lq.diagram(
  // title: [Days, step 2],
  lq.plot(
    (
      datetime(year: 2000, month: 2, day: 27),
      datetime(year: 2000, month: 3, day: 5),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Days, step 5],
  lq.plot(
    (
      datetime(year: 2000, month: 1, day: 17),
      datetime(year: 2000, month: 2, day: 5),
    ),
    (1, 2)
  )
)


#pagebreak()

#{
  show: lq.tick-format.set-datetime-smart-first(
    day: "[day]\n[month repr:short]"
  )

  lq.diagram(
    width: 10cm,
    lq.plot(
      (
        datetime(year: 2011, month: 1, day: 1),
        datetime(year: 2011, month: 3, day: 4)
      ),
      (1, 2)
    )
  )
}

#pagebreak()



#lq.diagram(
  // title: [Hours, single day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 2, minute: 5, second: 3),
      datetime(year: 2023, month: 1, day: 1, hour: 18, minute: 15, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Hours, cross-day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 12, minute: 5, second: 3),
      datetime(year: 2023, month: 1, day: 2, hour: 12, minute: 15, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Hours, 0:00],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 0, minute: 5, second: 3),
      datetime(year: 2023, month: 1, day: 1, hour: 12, minute: 15, second: 0),
    ),
    (1, 2)
  )
)



#pagebreak()

#lq.diagram(
  // title: [Minutes, single day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 2, minute: 15, second: 3),
      datetime(year: 2023, month: 1, day: 1, hour: 3, minute: 15, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Minutes, cross-day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 23, minute: 5, second: 3),
      datetime(year: 2023, month: 1, day: 2, hour: 1, minute: 15, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  title: [Minutes, 0:00],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 0, minute: 1, second: 3),
      datetime(year: 2023, month: 1, day: 1, hour: 1, minute: 20, second: 0),
    ),
    (1, 2)
  )
)

#pagebreak()



#lq.diagram(
  // title: [Seconds, single day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 2, minute: 15, second: 30),
      datetime(year: 2023, month: 1, day: 1, hour: 2, minute: 16, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Seconds, cross-day],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 23, minute: 59, second: 1),
      datetime(year: 2023, month: 1, day: 2, hour: 0, minute: 1, second: 0),
    ),
    (1, 2)
  )
)

#lq.diagram(
  // title: [Seconds, 0:00],
  lq.plot(
    (
      datetime(year: 2023, month: 1, day: 1, hour: 0, minute: 0, second: 0),
      datetime(year: 2023, month: 1, day: 1, hour: 0, minute: 0, second: 7),
    ),
    (1, 2)
  )
)



#pagebreak()


#lq.diagram(
  // title: [Minutes manual formatting],
  xaxis: (
    format-ticks: lq.format-ticks-datetime.with(
      format: (datetime, period: none) => {
        datetime.display("[minute]:[second]")
      },
      format-offset: (ticks, ..) => ticks.first().display("[hour]:[minute]")
    )
  ),
  lq.plot(
    (
      datetime(hour: 15, minute: 5, second: 3),
      datetime(hour: 15, minute: 6, second: 45),
    ),
    (1, 2)
  )
)

#pagebreak()


// Manual ticks
#let xs = (
  datetime(year: 2025, month: 5, day: 8),
  datetime(year: 2025, month: 5, day: 9),
)

#lq.diagram(
  xaxis: (ticks: xs),
  margin: 15%,
  lq.plot(xs, (1, 2))
)

#lq.diagram(
  xaxis: (ticks: xs.zip(("A", "B"))),
  margin: 15%,
  lq.plot(xs, (1, 2))
)


#pagebreak()


#lq.diagram(
  // title: [Weekdays],
  xaxis: (
    format-ticks: lq.format-ticks-datetime.with(format: "[weekday repr:short]"),
  ),
  lq.plot(
    (
      datetime(year: 2001, month: 1, day: 3),
      datetime(year: 2001, month: 1, day: 8)
    ), 
    (4, 5)
  )
)

#pagebreak()

// Overwrite offset
#lq.diagram(
  xaxis: (offset: [Y]),
  lq.plot((1,2), (1,2))
)





#import "/src/logic/time.typ"

// #assert.eq(
//   catch(
//     () => {
//       time.to-seconds(
//         datetime(year: 2025, month: 8, day: 4),
//         datetime(year: 2025, month: 8, day: 7),
//         datetime(year: 2025, month: 8, day: 7, hour: 3, minute: 3, second: 1)
//       )
//     },
//   ),
//   "assertion failed: All datetimes must be of the same type (all time, all date, or all datetime)."
// )

// #assert.eq(
//   catch(
//     () => {
//       time.to-seconds(
//         datetime(year: 2025, month: 8, day: 7, hour: 3, minute: 3, second: 1)
//         datetime(year: 2025, month: 8, day: 4),
//       )
//     },
//   ),
//   "assertion failed: All datetimes must be of the same type (all time, all date, or all datetime)."
// )

// #assert.eq(
//   catch(
//     () => {
//       time.to-seconds(
//         datetime(hour: 3, minute: 3, second: 1),
//         datetime(year: 2025, month: 8, day: 7, hour: 3, minute: 3, second: 1)
//       )
//     },
//   ),
//   "assertion failed: All datetimes must be of the same type (all time, all date, or all datetime)."
// )
// 




#pagebreak()

// twin axes

#lq.diagram(
  lq.plot((1, 2),(4,5)),
  xaxis: (position: bottom),
  lq.xaxis(
    position: top,
    lq.scatter(
      (
        datetime(year: 1, month: 1, day: 3),
        datetime(year: 2, month: 1, day: 3),
      ),
      (
        datetime(year: 2001, month: 1, day: 3),
        datetime(year: 2002, month: 1, day: 3),
      )
    )
  )
)



