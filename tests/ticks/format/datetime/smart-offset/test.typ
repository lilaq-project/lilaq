#import "/src/lilaq.typ" as lq
#import "@preview/elembic:1.1.0" as e
#import "/src/logic/tick-format.typ": display-datetime-smart-offset

#let test-datetime-smart-offset(offset, expected) = e.get(e-get => {
  assert.eq(
    display-datetime-smart-offset(e-get(lq.tick-format.datetime-smart-offset) + e.fields(offset)),
    expected
  )
})

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 4, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: none
  ),
  none
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 4, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  "0003"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 1, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  none
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 2, month: 11, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  none
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 1, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month",
    avoid-redundant: false
  ),
  "0003"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 1, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month",
    avoid-redundant: false,
    year: "[year padding:none]"
  ),
  "3"
)




#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day"
  ),
  "0003-Jul"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day",
    month: "[month repr:long]"
  ),
  "July"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 2, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day"
  ),
  none
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 8, day: 9),
    ),
    key: "day"
  ),
  "0003"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 7, day: 1),
      datetime(year: 3, month: 7, day: 7),
    ),
    key: "day"
  ),
  "0003"
)

#test-datetime-smart-offset(
  lq.tick-format.datetime-smart-offset(
    (
      datetime(year: 3, month: 7, day: 1),
      datetime(year: 3, month: 7, day: 7),
    ),
    key: "day",
    avoid-redundant: false
  ),
  "0003-Jul"
)