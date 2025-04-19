#set page(width: auto, height: auto, margin: 0pt)
#import "/src/lilaq.typ" as lq

//#let (λ, intensity) = lq.load-txt(read("spectrum_o2.txt"), skip-rows: 2, delimiter: " ")

#let λ = lq.linspace(600, 700, num: 1000)
#let intensity = lq.linspace(0.01, 0.89, num: 1000)


#let h = 6.62607015e-34
#let c = 299792458
#let e = 1.60217733e-19
#let k = 1e9 * h * c / e

#lq.diagram(
  width: 10cm,
  margin: 3%,

  xaxis: (offset: 0, mirror: false),
  xlabel: [Wavelength (nm)],
  ylabel: [Relative intensity],

  lq.plot(λ, intensity, mark: none),

  lq.xaxis(
    position: top,
    label: [Energie (eV)],
    offset: 0, 
    exponent: 0,
    tick-distance: 5e-5,
    functions: (λ => k / λ, E => k / E)
  )
)