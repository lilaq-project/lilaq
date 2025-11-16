#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq

#[

  #show: lq.set-label(pad: none)

  #lq.diagram(
    xaxis: (ticks: (.2, .8)),
    yaxis: (ticks: (.2, .8)),
    width: 2cm,
    height: 2cm,
    xlabel: $x$,
    ylabel: $y$,
  )

]

#pagebreak()

#[

  #show: lq.cond-set(lq.label.with(kind: "y"), angle: 0deg)

  #lq.diagram(
    xaxis: (ticks: none),
    yaxis: (ticks: none),
    width: 2cm,
    height: 2cm,
    xlabel: $x$,
    ylabel: $y$,
  )

]

#pagebreak()

// Labels with a size that is changed by a transformational show rule

#[

  #show lq.selector(lq.label): rotate.with(90deg, reflow: true)
  #show: lq.set-label(pad: 0pt)

  #lq.diagram(
    height: 3pt,
    xaxis: (ticks: none),
    yaxis: (ticks: none),
    xlabel: box(width: 30pt, fill: black, height: 1em),
  )

]


#pagebreak()

// Labels with a size that is changed by a transformational show rule

#[

  #show: lq.set-label(pad: 0pt)

  #lq.diagram(
    width: 3pt,
    xaxis: (ticks: none),
    yaxis: (ticks: none),
    ylabel: box(height: 30pt, fill: black, width: 1em),
  )

]
