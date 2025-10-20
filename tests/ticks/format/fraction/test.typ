#import "/src/lilaq.typ" as lq

#set page(width: auto, height: auto, margin: 10pt)

#{
  let a = lq.tick-locate.linear(0, 1, tick-distance: .25)
  lq.tick-format.fraction(
    a.ticks, tick-info: a
  ).labels.join("")
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 1, tick-distance: .25)
  lq.tick-format.fraction(
    a.ticks, tick-info: a, simplify: false
  ).labels.join("")
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(0, 1, tick-distance: .2)
  lq.tick-format.fraction(
    a.ticks, tick-info: a
  ).labels.join("")
}

// #pagebreak()

// #{
//   let a = lq.tick-locate.linear(0, 1, tick-distance: 1/3)
//   lq.tick-format.fraction(
//     a.ticks, tick-info: a
//   ).labels.join("")
// }

#pagebreak()

#{
  let a = lq.tick-locate.linear(-1, 1, tick-distance: .5)
  lq.tick-format.fraction(
    a.ticks, tick-info: a, simplify-integers: false
  ).labels.join("")
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(-1, 1, tick-distance: .5)
  lq.tick-format.fraction(
    a.ticks, tick-info: a, suffix: $pi$
  ).labels.join("")
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(-1, 1, tick-distance: .5)
  lq.tick-format.fraction(
    a.ticks, tick-info: a, suffix: $pi$, suffix-position: "numerator"
  ).labels.join("")
}

#pagebreak()

#{
  let a = lq.tick-locate.linear(-1, 1, tick-distance: .5)
  lq.tick-format.fraction(
    a.ticks, tick-info: a, suffix: $pi$, suffix-position: "numerator", omit-unity: false, simplify-integers: false, 
  ).labels.join("")
}