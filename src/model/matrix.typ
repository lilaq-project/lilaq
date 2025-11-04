#let matrix(
  columns: 1,
  rows: auto,
  ..children
) = {

}


#import "../lilaq.typ" as lq
#import "@local/elembic:1.1.0" as e


#let diagram-grid(it) = {
  if it.children.len() == 0 { return it }

  // protect from other grids such as the legend grid
  if it.children.all(cell => e.eid(cell.body) != e.eid(lq.diagram)) { return it }
  
  
  let table = context {
    
    let table-end = query(selector(<__lilaq_matrix__>)
      .after(here()))
      .first()
      .location()
    
    let diagram-meta = query(
      selector(<__lilaq_diagram__>).after(here()).before(table-end)
    ).map(metadata => metadata.value)


    if diagram-meta.len() == 0 { // first layout pass
      return {
        show grid.cell: it => {
          if e.eid(it.body) != e.eid(lq.diagram) {
            return it
          }
          

          show: lq.set-diagram(
            _grid-pos: (it.x, it.y, it.x + it.colspan - 1, it.y + it.rowspan - 1)
          )
          it
        }    
        it
      }
    }


    // let cols = calc.max(..diagram-meta.map(d => d.x)) + 1
    let cols = it.columns.len()
    let rows = calc.max(..diagram-meta.map(d => d.y)) + 1

    let left = range(cols)
      .map(col => {
        calc.max(0pt, ..diagram-meta.filter(d => d.x == col).map(d => d.left))
      })
    let right = range(cols)
      .map(col => {
        calc.max(0pt, ..diagram-meta.filter(d => d.xn == col).map(d => d.right))
      })
    let top = range(rows)
      .map(row => {
        calc.max(0pt, ..diagram-meta.filter(d => d.y == row).map(d => d.top))
      })
    let bottom = range(rows)
      .map(row => {
        calc.max(0pt, ..diagram-meta.filter(d => d.yn == row).map(d => d.bottom))
      })
      
    show grid.cell: it => {
      if e.eid(it.body) != e.eid(lq.diagram) {
        return it
      }
      
      let ppp = (it.x, it.y)
      if ppp != (0,0) {
        let ooo = ppp
      }
      let data = diagram-meta.find(d => d.x == it.x and d.y == it.y)
      if data == none { // cell may not contain a diagram
        return it
      }

      let pad = (
        left: left.at(it.x) - data.left, 
        right: right.at(it.x + it.colspan - 1) - data.right, 
        top: top.at(it.y) - data.top, 
        bottom: bottom.at(it.y + it.rowspan - 1) - data.bottom, 
      )
      show: lq.set-diagram(_grid-pos: (it.x, it.y, it.x + it.colspan - 1, it.y + it.rowspan - 1), pad: pad)
      it
    }
    it
  }
  table + [#metadata(none)<__lilaq_matrix__>]
}


#show: lq.set-diagram(width: 100%)
#show grid: diagram-grid

// #grid(
//   columns: (1fr, 1fr),
//   // rows: 1fr,
//   column-gutter: 1em,
//   row-gutter: 1em,
//   stroke: red,
//   lq.diagram(ylim: (-100, 10), title: [A ss asdd bb]),
//   lq.diagram(ylim: (1, 5)),
//   lq.diagram(xaxis: (position: top)),
//   lq.diagram(yaxis: (position: right, mirror: (ticks: true, tick-labels: true)), ylim: (-100, 10)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(xaxis: (position: top)),
//   lq.diagram(),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
//   lq.diagram(yaxis: (position: right)),
// )

// #show: lq.set-diagram(height: 4cm)
// #show lq.selector(lq.legend): none

// #grid(
//   columns:1,
//   // column-gutter: 1em,
//   // row-gutter: 1em,
//   stroke: red,
//   lq.diagram(
//     legend: (position: left, dx: 100%),
//     // legend: none,
//     lq.plot((1, 2), (3, 4), label: [A])
    
//   ),
//   lq.diagram(ylim: (1, 5), yaxis: (position: right)),
// )


// == Effect of non-adapting axis (a bearable compromise)
// #grid(
//   columns: (1fr, ),
//   lq.diagram(
//     legend: (position: left, dx: 100%+16em),
//     lq.plot((1, 1.8), (3, 4), label: [A])
//   ),
//   lq.diagram(
//     lq.plot((1, 1.8), (3, 4))
//   )
// )


#pagebreak()

#show: lq.set-diagram(width: 100%, height: 100%)

#grid(
  columns: 2,
  rows: 4cm,
  stroke: red,
  column-gutter: 1em, 
  row-gutter: 1em, 
  grid.cell(
    lq.diagram(yaxis: (position: right)),
    colspan: 2
  ),
  lq.diagram(title: [A]),
  grid.cell(
    lq.diagram(),
    rowspan: 3
  ),
  lq.diagram(title: [B]),
  lq.diagram(title: [C]),
)