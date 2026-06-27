#import "/src/lilaq.typ" as lq
#import "/tests/test-presets.typ"

#set page(margin: 5pt, width: auto, height: auto)


#show: test-presets.obfuscate
#show: test-presets.minimal

#lq.diagram(
  width: 3cm,
  height: 3cm,
  lq.plot((1,), (1,), label: "", use-cycle: false),
  lq.plot((1,), (2,), label: ""),
  lq.plot((1,), (3,), label: ""),
  lq.plot((1,), (4,), label: "", use-cycle: false),
  lq.plot((1,), (5,), label: ""),
)

#pagebreak()

#lq.diagram(
  width: 3cm,
  height: 3cm,
  lq.violin((1, 2, 3), use-cycle: false),
  lq.hviolin((1, 2, 3), use-cycle: false),
  lq.stem((1, 2, 3), (.1, .2, .3), use-cycle: false),
  lq.bar((1, 2, 3), (.1, .2, .3), use-cycle: false),
  lq.hstem((.1, .2, .3), (1, 2, 3), use-cycle: false),
  lq.hbar((.1, .2, .3), (1, 2, 3), use-cycle: false),
  lq.scatter((2, 3), (3, 3), use-cycle: false),
  lq.plot((2, 3), (2, 2), use-cycle: false),
)

#pagebreak()

#lq.diagram(
  width: 3cm,
  height: 3cm,
  lq.hlines(2, use-cycle: true),
  lq.vlines(2, use-cycle: true),
)
