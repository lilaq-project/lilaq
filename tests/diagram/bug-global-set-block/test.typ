#set page(width: 7cm, height: 4.5cm, margin: 5pt)
#import "/tests/test-presets.typ": *
#show: minimal
#show: obfuscate
#show: lq.set-tick(inset: 5pt, outset: 0pt, stroke: 0pt)



#set block(width: 100%, height: 100%)

#lq.diagram(
  width: 5cm,
  height: 3cm,
  lq.plot((1, 2, 3), (3, 2, 5), label: ""),
)
