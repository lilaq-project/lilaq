#set page(width: auto, height: auto, margin: 1pt)


#import "/src/lilaq.typ" as lq

#show lq.selector(lq.tick-label): box.with(fill: yellow)
// #show: lq.elembic.show_(lq.tick-label.with(sub: true), it => { set text(.8em); it })

#lq.diagram(
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