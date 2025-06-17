#set page(width: auto, height: auto, margin: 1pt)

#import "../../template.typ": *
#show: minimal

#lq.diagram(
  lq.plot(
    range(20),
    range(20).map(x => x*x),
    label: [A], 
    every: 4, 
  )
)