#import "utility.typ": place-in-out, match-type, match
#import "process-styles.typ": merge-strokes, merge-fills
#import "math.typ": minmax
#import "scale.typ"
// #import "markers.typ": markers


#let plot-lim(x, err: none) = {
  if err == none { return minmax(x) }
  
  return (
    calc.min(..array.zip(x, err).map(((x, err)) => x - if type(err) == array { err.at(0) } else { err })),
    calc.max(..array.zip(x, err).map(((x, err)) => x + if type(err) == array { err.at(1) } else { err })),
  )
}

#let bar-lim(x, base) = {
  let lim = minmax(x + base)
  let (base-min, base-max) = minmax(base)
  if lim.at(0) == base-min { lim.at(0) *= 1fr }
  if lim.at(1) == base-max { lim.at(1) *= 1fr }
  return lim
}



// #let get-marker-function(marker) = {
  // if marker == none {  return size => none }
  // if type(marker) == function {  return marker }
  // if type(marker) == str and marker in markers {
  //   return markers.at(marker)
  // }
  // assert(false, message: "Unknown marker " + repr(marker))
// }
