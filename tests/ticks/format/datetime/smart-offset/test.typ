#import "/src/algorithm/ticking.typ": *
#let test-smart-offset(offset, expected) = e.get(e-get => {
  assert.eq(
    display-smart-offset(e-get(smart-offset) + e.fields(offset)),
    expected
  )
})

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 4, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: none
  ),
  none
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 4, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  "0003"
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 1, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  none
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 2, month: 11, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month"
  ),
  none
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 1, day: 5),
      datetime(year: 3, month: 7, day: 5),
    ),
    key: "month",
    avoid-redundant: false
  ),
  "0003"
)

#test-smart-offset(
  smart-offset(
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




#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day"
  ),
  "0003-Jul"
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day",
    month: "[month repr:long]"
  ),
  "July"
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 2, month: 7, day: 5),
      datetime(year: 3, month: 7, day: 9),
    ),
    key: "day"
  ),
  none
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 7, day: 5),
      datetime(year: 3, month: 8, day: 9),
    ),
    key: "day"
  ),
  "0003"
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 7, day: 1),
      datetime(year: 3, month: 7, day: 7),
    ),
    key: "day"
  ),
  "0003"
)

#test-smart-offset(
  smart-offset(
    (
      datetime(year: 3, month: 7, day: 1),
      datetime(year: 3, month: 7, day: 7),
    ),
    key: "day",
    avoid-redundant: false
  ),
  "0003-Jul"
)