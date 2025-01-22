
#import "process-styles.typ": update-stroke, process-margin, process-grid-arg
#import "assertations.typ"
#import "scale.typ"
#import "components/legend.typ": legend as lq-legend
#import "components/grid.typ": grid as lq-grid

#import "components/axis.typ": axis, draw-axis, axis-compute-limits, axis-generate-ticks
#import "ticking.typ"
#import "bounds.typ": *
#import "components/title.typ": title as title-constructor, title-show
#import "utility.typ": if-auto

#let debug = false
#import "cycle.typ": init as cycle-init, default-cycle
#import "libs/elembic/lib.typ" as e


/// Creates a new diagram. 
/// 
/// -> lq.diagram
#let diagram(
  
  /// Width of the diagram area. 
  width: 6cm,
  
  /// Height of the diagram area. 
  height: 4cm,

  /// Title for the diagram. Use a `lq.title` object for more options. 
  /// -> lq.title | str | content |  none
  title: none,

  /// Whether to show a legend with entries for all labelled plot objects. 
  /// -> boolean
  legend: true,

  /// Data limits along the $x$-axis. Expects `auto` or a tuple `(min, max)` where `min` and `max` may be `auto`. The minimum may be larger than the maximum. 
  /// -> auto |  array
  xlim: auto,
  
  /// Data limits along the $y$-axis. Expects `auto` or a tuple `(min, max)` where `min` and `max` may be `auto`. The minimum may be larger than the maximum. 
  /// -> auto |  array
  ylim: auto,

  /// Label for the $x$-axis. Use a `lq.xlabel` object for more options. 
  /// -> content | lq.xlabel
  xlabel: none,

  /// Label for the $y$-axis. Use a `lq.ylabel` object for more options. 
  /// -> content | lq.ylabel
  ylabel: none,


  /// -> auto | none | dictionary | color | length | stroke
  grid: auto,

  /// Sets the scale of the $x$-axis. This may be a `lq.scale` object or the name of one of the built-in scales `"linear"`, `"log"`, `"symlog"`.
  /// -> str | lq.scale
  xscale: "linear",
  
  /// Sets the scale of the $y$-axis. This may be a `lq.scale` object or the name of one of the built-in scales `"linear"`, `"log"`, `"symlog"`.
  /// -> str | lq.scale
  yscale: "linear",

  /// Configures the $x$-axis. This can be a `lq.xaxis` object or a dictionary of arguments to pass to the constructor of the axis. 
  /// lq.xaxis | dictionary
  xaxis: (:),
  
  /// Configures the $y$-axis. This can be a `lq.xaxis` object or a dictionary of arguments to pass to the constructor of the axis. 
  /// lq.xaxis | dictionary
  yaxis: (:),

  /// Configures the automatic margins of the diagram around the data. If set to `0%`, the outer-most data points align tightly with the edges of the diagram (as long as the axis limits are left at `auto`). Otherwise, the margin are computed in percent of the covered range along an axis (in scaled coordinates). 
  /// 
  /// -> ratio | dictionary
  margin: 6%,
  
  /// Style cycle to use for this diagram. 
  /// -> array
  cycle: default-cycle,

  /// Plot objects. 
  /// -> any
  ..children
) = {
  assertations.assert-no-named(children)
  set math.equation(numbering: none)
  set path(stroke: .7pt)
  let plots = ()
  let (xplots, yplots) = ((), ())
  let axes = ()
  for child in children.pos() {
    if type(child) == dictionary {
      if child.at("type", default: "") == "axis" {
        axes.push(child)
        // plots += child.plots
        if child.plots.len() > 0 {
          if child.kind == "x" {
            yplots += child.plots
          } else {
            xplots += child.plots
          }
        } else {
          plots += child.plots
        }
      } else {
        plots.push(child)
      }
    }
  }
  if xaxis == none { xaxis = (hidden: true) }
  if yaxis == none { yaxis = (hidden: true) }
  if type(xaxis) == dictionary {
    xaxis = axis(kind: "x", label: xlabel, scale: xscale, lim: xlim, ..xaxis)
  }
  xaxis.plots = plots + xplots
  if type(yaxis) == dictionary {
    yaxis = axis(kind: "y", label: ylabel, scale: yscale, lim: ylim, ..yaxis)
  }
  yaxis.plots = plots + yplots


  margin = process-margin(margin)

  xaxis.lim = axis-compute-limits(xaxis, lower-margin: margin.left, upper-margin: margin.right)
  yaxis.lim = axis-compute-limits(yaxis, lower-margin: margin.bottom, upper-margin: margin.top)

  
  let normalized-x-trafo = scale.create-trafo(xaxis.scale.transform, ..xaxis.lim)
  let normalized-y-trafo = scale.create-trafo(yaxis.scale.transform, ..yaxis.lim)

  xaxis.normalized-scale-trafo = normalized-x-trafo
  yaxis.normalized-scale-trafo = normalized-y-trafo
  xaxis.transform = x => normalized-x-trafo(x) * width
  yaxis.transform = y => height * (1 - normalized-y-trafo(y))
  
  let transform(x, y) = (
    width * normalized-x-trafo(x), 
    height * (1 - normalized-y-trafo(y))
  )

  
  let maybe-transform(x, y) = {
    if type(x) in (int, float) { x = (xaxis.transform)(x) }
    if type(y) in (int, float) { y = (yaxis.transform)(y) - height }
    return (x, y)
  }
  yaxis.translate = maybe-transform(..yaxis.translate)
  xaxis.translate = maybe-transform(..xaxis.translate)
  
  for i in range(axes.len()) {
    let axis = axes.at(i)
    let model-axis = if axis.kind == "x" {xaxis} else {yaxis}
    let has-auto-lim = axis.lim == auto
    let has-auto-lim = false
    axes.at(i).lim = axis-compute-limits(axis, default-lim: model-axis.lim)

    if axis.plots.len() > 0 {
      let other-axis = if axis.kind == "x" {yaxis} else {xaxis}
      let transform
      let scale-trafo = scale.create-trafo(axis.scale.transform, ..axes.at(i).lim)
      if axis.kind == "x" {
        let normalized-x-trafo = scale-trafo
        transform = (x, y) => (normalized-x-trafo(x) * width, height * (1 - normalized-y-trafo(y)))
        axes.at(i).transform = x => normalized-x-trafo(x) * width
      } else {
        let normalized-y-trafo = scale-trafo
        transform = (x, y) => (normalized-x-trafo(x) * width, height * (1 - normalized-y-trafo(y)))
        axes.at(i).transform = y => (1 - normalized-y-trafo(y)) * height
      }
      plots.push((
        type: "axis-collection", // TODO: add legend entries
        plots: axis.plots,
        transform: transform
      ))
    } else {
      plots += axis.plots
      axes.at(i).transform = if has-auto-lim {model-axis.transform} else {
        let trafo = x => (model-axis.normalized-scale-trafo)((axis.functions.inv)(x))
        if axis.kind == "y" {
          y => height * (1 - trafo(y))
        } else {
          x => width * trafo(x)
        }
      }
    }
  }

  
  
  context e.get(e-get => {
  
  let axis-info = (
    x: (ticking: axis-generate-ticks(xaxis, length: width)), 
    y: (ticking: axis-generate-ticks(yaxis, length: height)), 
    rest: ((:),) * axes.len()
  )
    

  let bounds = (left: 0pt, right: width, top: 0pt, bottom: height)
  


    
  let diagram = box(
    width: width, height: height, 
    inset: 0pt, stroke: none, 
    {
    

    let artists = ()
    artists.push((
      content: {
        let x-transform = tick => transform(tick, 1).at(0)
        let y-transform = tick => transform(1, tick).at(1)
        lq-grid(
          axis-info.x.ticking.ticks.map(x-transform),
          axis-info.x.ticking.subticks.map(x-transform),
          kind: "x",
          ..process-grid-arg(grid)
        )
        lq-grid(
          axis-info.y.ticking.ticks.map(y-transform),
          axis-info.y.ticking.subticks.map(y-transform),
          kind: "y",
          ..process-grid-arg(grid)
        )
      }, z: e-get(lq-grid).z-index
    ))

    let legend-entries = ()

    
// #let create-legend-entries(plots) = {
//   plots
//     .filter(plot => "legend-handle" in plot)
//     .map(plot =>
//       (
//         box(width: 2em, height: .7em, (plot.legend-handle)(plot)), 
//         plot.label
//       )
//     )
// }

    
    for (i, plot) in plots.enumerate() {
      let cycle-style = cycle.at(calc.rem(i, cycle.len()))
      let plotted-plot = {
        show: cycle-init
        show: cycle-style
        if plot.at("type", default: "") == "axis-collection" {
          let transform = plot.transform
          for plot in plot.plots {
            (plot.plot)(plot, transform)
          }
        } else {
          (plot.plot)(plot, transform)
        }
        if "legend-handle" in plot and plot.label != none {
          let handle = (plot.legend-handle)(plot)
          if "new-legend" in plot {
            plot.make-legend = true
            let legend-trafo(x, y) = {
              (x*100%, (1-y)*100%)
            }
            handle = {
              show: cycle-init
              show: cycle-style
              (plot.plot)(plot, legend-trafo)
            }
          }
          legend-entries.push((
            box(width: 2em, height: .7em, handle),
            plot.label
          ))
        }
      }
      if plot.at("clip", default: true) { 
        plotted-plot = place(box(width: width, height: height, clip: true, plotted-plot))
      }
      artists.push((content: plotted-plot, z: plot.at("z-index", default: 2)))
    }


    let show-bounds(bounds, clr: red) = {
      place(dx: bounds.left, dy: bounds.top, rect(width: bounds.right - bounds.left, height: bounds.bottom - bounds.top, fill: clr))
    }
    if not debug {
      show-bounds = (args, clr: red) => none
    }

    let minor-axis-style = (
      inset: 2pt,
      outset: 0pt,
      type: "minor"
    )
    let major-axis-style = (
      inset: 4pt,
      outset: 0pt,
      type: "major"
    )
    let get-axis-args(axis) = {
      if axis.kind == "x" { 
        (length: width)
      } else {
        (length: height)
      }
    }
    let (xaxis-, max-xtick-size) = draw-axis(xaxis, axis-info.x.ticking, major-axis-style, e-get: e-get)
    artists.push((content: xaxis-, z: 2.1))

    let (yaxis-, max-ytick-size) = draw-axis(yaxis, axis-info.y.ticking, major-axis-style, e-get: e-get)
    artists.push((content: yaxis-, z: 2.1))
 
    if type(max-ytick-size) == array {
      for b in max-ytick-size {
        bounds = update-bounds(bounds, b, width: width, height: height)
        show-bounds(b, clr: rgb("#22AA2222"))
      }
      for b in max-xtick-size {
        bounds = update-bounds(bounds, b, width: width, height: height)
        show-bounds(b, clr: rgb("#AAAA2222"))
      }
    } else {
      padding.left = max-ytick-size
      padding.bottom = max-xtick-size
    }

    for axis in axes {
      let ticking = axis-generate-ticks(axis, ..get-axis-args(axis))
      let (axis-, axis-bounds) = draw-axis(axis, ticking, major-axis-style, e-get: e-get)
      artists.push((content: axis-, z: 2.1))

      
      for b in axis-bounds {
        bounds = update-bounds(bounds, b, width: width, height: height)
        show-bounds(b, clr: rgb("#2222AA22"))
      }
    }
    

    if title != none {
      let title = title
      if e.eid(title) != e.eid(title-constructor) {
        title = title-constructor(title)
      }
      let nested-get-field(element, object, field) = {
        e.fields(object).at(field, default: e-get(element).at(field))
      }

      let pos = nested-get-field(title-constructor, title, "pos")
      let dx = if-auto(nested-get-field(title-constructor, title, "dx"), 0pt)
      let dy = if-auto(nested-get-field(title-constructor, title, "dy"), 0pt)
      let pad = if-auto(nested-get-field(title-constructor, title, "pad"), 0pt)

      let wrapper = if pos in (top, bottom) {
        box.with(width: width)
      } else if pos in (left, right) {
        box.with(height: height)
      }

      let body = wrapper(title)
      
      let (title, b) = place-with-bounds(body, alignment: pos, dx: dx, dy: dy, pad: pad)
      
      artists.push((content: title, z: 3))
      bounds = update-bounds(bounds, b, width: width, height: height)
    }

    
    if legend != none and legend != false and legend-entries.len() > 0 {
      let legend = legend
      if legend == true { legend = (:) }

      let legend-content = {
        // set text(size: .9em)
        set table(columns: 2, stroke: none, inset: 2pt, align: horizon + left)
        lq-legend(..legend-entries)
      }

      artists.push((content: legend-content, z: e-get(lq-legend).z-index))
    }
    artists.sorted(key: artist => artist.z).map(artist => artist.content).join()
  })
  bounds.bottom -= height
  bounds.right -= width
  bounds.left *= -1
  bounds.top *= -1
  box(box(inset: bounds, diagram, stroke: if debug {.1pt} else {0pt}), baseline: bounds.bottom)
})
}