#import "/src/lilaq.typ" as lq
#import "/tests/test-presets.typ"

#set page(width: auto, height: auto, margin: 1pt)



#show: test-presets.obfuscate
#show: test-presets.minimal

#show: lq.set-diagram(width: 3cm, height: 2cm)



#lq.diagram(bounds: "strict")

#pagebreak()

#lq.diagram(bounds: "relaxed")

#pagebreak()

#lq.diagram(bounds: "data-area")
