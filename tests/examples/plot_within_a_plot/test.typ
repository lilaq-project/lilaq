#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#let weierstrass(x, k: 8) = {
  range(k).map(k => calc.pow(0.5, k) * calc.cos(calc.pow(5, k) * x)).sum()
}

#let xs = lq.linspace(-0.5, .5, num: 1000)
#let xs-fine = lq.linspace(-0.05, 0, num: 1000)

#show: lq.set-grid(stroke: none)

#lq.diagram(
  width: 14cm, 
  height: 7cm,
  ylim: (0, 2),
  margin: (x: 2%),

  lq.plot(xs, mark: none, xs.map(weierstrass)),

  lq.rect(-0.05, 1.5, width: .05, height: .3),

  lq.place(
    60%, 100% - 1.2em, 
    align: bottom,
    lq.diagram(
      width: 5.4cm, height: 2cm, 
      margin: 0%,
      ylim: (1.5, 1.8),
      fill: white,
      lq.plot(xs-fine, mark: none, xs-fine.map(weierstrass)),
    )
  )
)