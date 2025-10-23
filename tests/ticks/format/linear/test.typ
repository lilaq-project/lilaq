#import "/src/lilaq.typ" as lq

#set page(width: auto, height: auto, margin: 10pt)

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: .5)
  lq.tick-format.linear(
    a.ticks, tick-info: a
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: .5)
  lq.tick-format.linear(
    a.ticks, tick-info: a, pad: false
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: .5)
  lq.tick-format.linear(
    a.ticks, tick-info: a, suffix: $pi$
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: .5)
  lq.tick-format.linear(
    a.ticks, tick-info: a, suffix: $pi$, pad: false
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: 1)
  lq.tick-format.linear(
    a.ticks, tick-info: a, offset: -1
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 2, tick-distance: 1)
  lq.tick-format.linear(
    a.ticks, tick-info: a, exponent: -1
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 200, tick-distance: 100)
  lq.tick-format.linear(
    a.ticks, tick-info: a
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 200, tick-distance: 100)
  lq.tick-format.linear(
    a.ticks, tick-info: a, auto-exponent-threshold: 100
  ).labels.join()
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 200, tick-distance: 100)
  lq.tick-format.linear(
    a.ticks, tick-info: a, exponent: "inline"
  ).labels.join()
}

#pagebreak()

// automatic tick distance computation

#{
  lq.tick-format.linear(
    (1, 1.2, 1.4), 
  ).labels.join()
}
