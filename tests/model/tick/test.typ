#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq

#show: lq.show_(lq.tick-label.with(sub: true), it => { set text(.8em); it })


#{
  show lq.selector(lq.tick-label): box.with(fill: yellow)

  lq.diagram(
    width: 3cm,
    height: 2cm,
    xaxis: (
      ticks: none,
      extra-ticks: (
        0.1, 
        lq.tick(0.3, inset: 2pt, outset: 2pt, stroke: red),
        lq.tick(0.5, label: $e$, sub: true, pad: 0em),
      )
    ),
    yaxis: (
      ticks: none,
      mirror: (ticks: true, tick-labels: true),
      extra-ticks: (
        0.1, 
        lq.tick(0.3),
        lq.tick(0.5, label: lq.tick-label(sub: true)[Test]),
      )

    )
  )
}

#pagebreak()

#lq.diagram(
  width: 1cm, height: 2cm,
  xaxis: (
    ticks: none,
    extra-ticks: (lq.tick(.5, label: [A very very very long tick label]),),
  ),
  yaxis: (
    ticks: none,
    extra-ticks: (lq.tick(.5, label: [Long label]),),
  )
)


#pagebreak()


// Check that labels are measured AFTER they are converted to lq.tick-label, 
// see issue #89. 

#{
  show: lq.show_(lq.tick-label.with(kind: "x"), rotate.with(-90deg, reflow: true))

  lq.diagram(
    width: 3cm,
    grid: none,
    height: 1cm,
    ylim: (-0.2, 1.2),
    xlim: (-0.01, 0.11),
  )
}


#pagebreak()


//
#show: lq.show_(lq.tick-label.with(kind: "x", sub: true), rotate.with(-90deg, reflow: true))

#lq.diagram(
  width: 3cm, 
  height: 2cm, 
  grid: none,
  xlim: (-1, 1.1),
  ylim: (1, 3.2),
  xaxis: (
    format-subticks: lq.format-ticks-linear,
    subticks: 1,
  ),
  yaxis: (
    format-subticks: lq.format-ticks-linear,
    subticks: 1
  ),
)