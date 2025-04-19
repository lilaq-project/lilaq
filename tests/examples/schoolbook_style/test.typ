#set page(width: auto, height: auto, margin: 0pt)
#import "/src/lilaq.typ" as lq

#import "@preview/tiptoe:0.3.0"

#let schoolbook-style = it => {
  let filter(value, distance) = value != 0 and distance >= 5pt
  let axis-args = (position: 0, filter: filter)
  
  show: lq.set-tick(inset: 2pt, outset: 2pt, pad: 0.4em)
  show: lq.set-spine(tip: tiptoe.stealth)
  show: lq.set-diagram(xaxis: axis-args, yaxis: axis-args)
  it
}

#show: schoolbook-style

#lq.diagram()