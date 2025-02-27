#import "libs/elembic/lib.typ" as e: selector
#import "model/grid.typ": grid
#import "model/label.typ": label
#import "model/title.typ": title
#import "model/legend.typ": legend
#import "model/tick.typ": tick
#import "model/spine.typ": spine

#let set_ = e.set_
#let set-grid = e.set_.with(grid)
#let set-title = e.set_.with(title)
#let set-label = e.set_.with(label)
#let set-legend = e.set_.with(legend)
#let set-tick = e.set_.with(tick)
#let set-spine = e.set_.with(spine)