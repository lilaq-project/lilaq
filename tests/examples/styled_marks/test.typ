#set page(width: auto, height: auto, margin: 5pt)
#import "/src/lilaq.typ" as lq

#let xs = lq.linspace(0, 4 * calc.pi)
#let ys = xs.map(calc.sin)

#import "@preview/suiji:0.3.0"
#let rng = suiji.gen-rng(33)

#let (rng, noise) = suiji.normal(
  scale: 0.1, size: xs.len(), rng
)

#let xs-noisy = lq.vec.add(xs, noise)