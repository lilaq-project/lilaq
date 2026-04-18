#set page(width: auto, height: auto, margin: 1pt)
#import "../template.typ": *
#show: minimal

// Check that extreme coordinates (which may not be supported for PDF export) are clamped. 
// See issues #70, #197.

#lq.diagram(
  lq.plot(
    lq.linspace(-calc.pi/2, calc.pi/2, num: 100),
    calc.tan,
    mark: none
  ),
  ylim: (-4,4),
  xlim: (-calc.pi/2, calc.pi/2)
)
