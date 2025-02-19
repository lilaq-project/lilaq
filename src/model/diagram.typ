
#import "../process-styles.typ": update-stroke, process-margin, process-grid-arg
#import "../assertations.typ"
#import "../logic/scale.typ"
#import "../logic/transform.typ": create-trafo
#import "legend.typ": legend as lq-legend, place-legend-with-bounds
#import "grid.typ": grid as lq-grid

#import "axis.typ": axis, draw-axis, _axis-compute-limits, _axis-generate-ticks
#import "../algorithm/ticking.typ"
#import "../bounds.typ": *
#import "title.typ": title as lq-title, title-show
#import "../utility.typ": if-auto

#let debug = false
#import "../cycle.typ": init as cycle-init, default-cycle
#import "../libs/elembic/lib.typ" as e


/// Creates a new diagram. 
/// 
/// -> lq.diagram
#let diagram(
  
  /// Width of the diagram area. 
  width: 6cm,
  
  /// Height of the diagram area. 
  height: 4cm,

  /// Title for the diagram. Use a @title object for more options. 
  /// -> lq.title | str | content |  none
  title: none,

  /// Whether to show a legend with entries for all labelled plot objects. 
  /// -> bool
  legend: true,

  /// Data limits along the $x$-axis. Expects `auto` or a tuple `(min, max)` where `min` and `max` may be `auto`. The minimum may be larger than the maximum. 
  /// -> auto |  array
  xlim: auto,
  
  /// Data limits along the $y$-axis. Expects `auto` or a tuple `(min, max)` where `min` and `max` may be `auto`. The minimum may be larger than the maximum. 
  /// -> auto |  array
  ylim: auto,

  /// Label for the $x$-axis. Use a @label object for more options. 
  /// -> content | lq.xlabel
  xlabel: none,

  /// Label for the $y$-axis. Use a @label object for more options. 
  /// -> content | lq.ylabel
  ylabel: none,


  /// -> auto | none | dictionary | color | length | stroke
  grid: auto,

  /// Sets the scale of the $x$-axis. This may be a @scale object or the name of one of the built-in scales `"linear"`, `"log"`, `"symlog"`.
  /// -> str | lq.scale
  xscale: "linear",
  
  /// Sets the scale of the $y$-axis. This may be a @scale object or the name of one of the built-in scales `"linear"`, `"log"`, `"symlog"`.
  /// -> str | lq.scale
  yscale: "linear",

  /// Configures the $x$-axis. This can be a @axis object or a dictionary of arguments to pass to the constructor of the axis. 
  /// lq.xaxis | dictionary
  xaxis: (:),
  
  /// Configures the $y$-axis. This can be a @axis object or a dictionary of arguments to pass to the constructor of the axis. 
  /// lq.xaxis | dictionary
  yaxis: (:),

  /// Configures the automatic margins of the diagram around the data. If set to `0%`, the outer-most data points align tightly with the edges of the diagram (as long as the axis limits are left at `auto`). Otherwise, the margin are computed in percent of the covered range along an axis (in scaled coordinates). 
  /// 
  /// -> ratio | dictionary
  margin: 6%,
  
  /// Style cycle to use for this diagram. 
  /// -> array
  cycle: default-cycle,

  /// How to fill the data area. 
  /// -> none | color | gradient | tiling 
  fill: none,

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

  xaxis.lim = _axis-compute-limits(xaxis, lower-margin: margin.left, upper-margin: margin.right)
  yaxis.lim = _axis-compute-limits(yaxis, lower-margin: margin.bottom, upper-margin: margin.top)

  
  let normalized-x-trafo = create-trafo(xaxis.scale.transform, ..xaxis.lim)
  let normalized-y-trafo = create-trafo(yaxis.scale.transform, ..yaxis.lim)

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
    axes.at(i).lim = _axis-compute-limits(axis, default-lim: model-axis.lim)

    if axis.plots.len() > 0 {
      let other-axis = if axis.kind == "x" {yaxis} else {xaxis}
      let transform
      let scale-trafo = create-trafo(axis.scale.transform, ..axes.at(i).lim)
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
        type: "axis-collection", 
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

  
  
  e.get(e-get => {
  
  let axis-info = (
    x: (ticking: _axis-generate-ticks(xaxis, length: width)), 
    y: (ticking: _axis-generate-ticks(yaxis, length: height)), 
    rest: ((:),) * axes.len()
  )
    

  let bounds = (left: 0pt, right: width, top: 0pt, bottom: height)
  


    
  let diagram = box(
    width: width, height: height, 
    inset: 0pt, stroke: none, fill: fill,
    {
    set align(top + left) // sometimes alignment is messed up


    let update-bounds = update-bounds.with(width: width, height: height)
    

    let artists = ()
    artists.push((
      content: {
        let x-transform = tick => transform(tick, 1).at(0)
        let y-transform = tick => transform(1, tick).at(1)
        lq-grid(
          axis-info.x.ticking.subticks.map(x-transform),
          true,
          kind: "x",
          ..process-grid-arg(grid)
        )
        lq-grid(
          axis-info.y.ticking.subticks.map(y-transform),
          true,
          kind: "y",
          ..process-grid-arg(grid)
        )
        lq-grid(
          axis-info.x.ticking.ticks.map(x-transform),
          false,
          kind: "x",
          ..process-grid-arg(grid)
        )
        lq-grid(
          axis-info.y.ticking.ticks.map(y-transform),
          false,
          kind: "y",
          ..process-grid-arg(grid)
        )
      }, z: e-get(lq-grid).z-index
    ))

    let legend-entries = ()


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
        bounds = update-bounds(bounds, b)
        show-bounds(b, clr: rgb("#22AA2222"))
      }
      for b in max-xtick-size {
        bounds = update-bounds(bounds, b)
        show-bounds(b, clr: rgb("#AAAA2222"))
      }
    } else {
      padding.left = max-ytick-size
      padding.bottom = max-xtick-size
    }

    for axis in axes {
      let ticking = _axis-generate-ticks(axis, ..get-axis-args(axis))
      let (axis-, axis-bounds) = draw-axis(axis, ticking, major-axis-style, e-get: e-get)
      artists.push((content: axis-, z: 2.1))

      
      for b in axis-bounds {
        bounds = update-bounds(bounds, b)
        show-bounds(b, clr: rgb("#2222AA22"))
      }
    }
    
    let get-settable-field(element, object, field) = {
      e.fields(object).at(field, default: e-get(element).at(field))
    }

    if title != none {
      let title = title
      if e.eid(title) != e.eid(lq-title) {
        title = lq-title(title)
      }

      let pos = get-settable-field(lq-title, title, "pos")
      let dx = if-auto(get-settable-field(lq-title, title, "dx"), 0pt)
      let dy = if-auto(get-settable-field(lq-title, title, "dy"), 0pt)
      let pad = if-auto(get-settable-field(lq-title, title, "pad"), 0pt)

      let wrapper = if pos in (top, bottom) {
        box.with(width: width)
      } else if pos in (left, right) {
        box.with(height: height)
      }

      let body = wrapper(title)
      
      let (title, b) = place-with-bounds(body, alignment: pos, dx: dx, dy: dy, pad: pad)
      
      artists.push((content: title, z: 3))
      bounds = update-bounds(bounds, b)
    }

    
    if legend != none and legend != false and legend-entries.len() > 0 {
      let (legend-content, legend-bounds) = place-legend-with-bounds(legend, legend-entries, e-get)

      artists.push((content: legend-content, z: e-get(lq-legend).z-index))

      bounds = update-bounds(bounds, legend-bounds)
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