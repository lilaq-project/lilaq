#import "../process-styles.typ": twod-ify-alignment



#let create-legend-entries(plots) = {
  plots
    .filter(plot => "legend-handle" in plot)
    .map(plot =>
      (
        box(width: 2em, height: .7em, (plot.legend-handle)(plot)), 
        plot.label
      )
    )
}


#let draw-legend(
  legend-info,
  fill: rgb(255, 255, 255, 200),
  stroke: 0.5pt + gray,
  inset: 3pt,
  ..children
) = {
  let alignment = twod-ify-alignment(
    legend-info.at("pos", default: top + right)
  )
  
  let dx = legend-info.at("dx", default: auto)
  let dy = legend-info.at("dy", default: auto)
  
  if dx == auto {
    if alignment.x == left { dx = 2pt }
    else if alignment.x == right { dx = -2pt }
    else { dx = 0pt }
  }
  if dy == auto {
    if alignment.y == top { dy = 2pt }
    else if alignment.y == bottom { dy = -2pt }
    else { dy = 0pt }
  }
  
  place(alignment, dx: dx, dy: dy, 
    rect(
      stroke: stroke,
      inset: inset,
      fill: fill,
      table(
        columns: 2, 
        align: horizon + left, 
        stroke: none, 
        inset: 2pt,
        ..children.pos().flatten(), 
      )
    )
  )
}
