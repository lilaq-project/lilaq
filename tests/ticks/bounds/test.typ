#set page(width: auto, height: auto, margin: 1pt)

#import "/src/lilaq.typ" as lq


// Tick labels with a size that is changed by a transformational show rule

#[

  #show lq.selector(lq.tick-label): it => box(fill: gray, hide(it))
  #show lq.selector(lq.tick-label): rotate.with(90deg, reflow: true)
  #show: lq.set-tick(pad: 1pt)

  #lq.diagram(
    height: 3pt,
    xlim: (.1, .9),
    xaxis: (subticks: none),
    yaxis: (ticks: none),
  )

]

#pagebreak()


#[

  #show lq.selector(lq.tick-label): it => box(fill: gray, hide(it))
  #show lq.selector(lq.tick-label): rotate.with(90deg, reflow: true)
  #show: lq.set-tick(pad: 0pt)

  #lq.diagram(
    width: 3pt,
    ylim: (.1, .9),
    yaxis: (subticks: none),
    xaxis: (ticks: none),
  )

]
