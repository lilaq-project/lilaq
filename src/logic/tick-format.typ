#import "@preview/zero:0.4.0"
#import "../math.typ": pow10
#import "tick-locate.typ": _estimate-significant-digits
#import "../logic/time.typ"




/// Formats ticks with explicit labels. See @tick-locate.manual. 
#let manual(

  /// The ticks to format
  /// -> array
  ticks, 

  /// Additional information from the tick locator. 
  /// -> dictionary
  tick-info: (:), 
  
  /// Arguments that are ignored by this formatter. 
  /// -> any
  ..args

) = {
  assert(
    "labels" in tick-info, message: "No labels given to `tick-format.manual`"
  )

  tick-info.labels
}



#let naive(
  ticks,
  ..args 
) = ticks.map(str)



#let num(
  value, 
  sign: 1,
  e: none, 
  auto-e: true,
  digits: auto, 
  base: 10, 
  omit-unit-mantissa: true
) = {
  if digits != auto {
    digits = calc.max(0, digits)
  }
  if e == 0 and auto-e { e = none }
  if e != none { 
    e = str(e)
  }
  zero.num(
    (
      mantissa: str(value).replace(sym.minus, "-"), 
      pm: none, 
      e: e
    ), 
    base: base, 
    digits: digits, 
    omit-unity-mantissa: omit-unit-mantissa
  )
}


#let default-generate-tick-label(
  value, 
  exponent: 0, 
  digits: auto, 
  simple: false
) = {
  if simple {
    if exponent == 0 { return $#value$ }
    return $#value dot 10^#exponent$
  }
  if exponent == 0 { exponent = none }
  return num(value, e: exponent, digits: digits)
}


/// Formats linear ticks, see @tick-locate.linear. This is the most common tick
/// formatter. 
#let linear(

  /// The ticks to format.
  /// -> array. 
  ticks,

  /// The exponent to apply to the ticks. 
  /// -> auto | int | "inline"
  exponent: auto,

  /// The offset to apply to the ticks. 
  /// -> auto | int | float
  offset: auto,

  /// Determines the threshold for automatic exponents to kick in. 
  /// -> int
  auto-exponent-threshold: 3,

  /// A suffix to display with each tick label. 
  /// -> content
  suffix: none,

  /// Additional information from the tick locator. 
  /// -> dictionary
  tick-info: (:), 
  
  /// Arguments that are ignored by this formatter. 
  /// -> any
  ..args

) = {
  
  let unit = tick-info.at("unit", default: 1)

  if offset == auto {
    offset = tick-info.at("offset", default: 0)
  } else {
    assert(type(offset) in (int, float), message: "Offsets need to be of integer or float type")
  }
  
  let additional-exponent = 0 // extra exp that will be shown on the axis
  let inline-exponent = 0     // extra exp that is shown for each tick

  let inherited-exponent = tick-info.at("exponent", default: 0)
  
  if exponent == none { exponent = 0 }
  if exponent == auto {
    if calc.abs(inherited-exponent) >= auto-exponent-threshold {
      additional-exponent = inherited-exponent
    }
  } else if exponent == "inline" {
    if calc.abs(inherited-exponent) >= auto-exponent-threshold {
      inline-exponent = inherited-exponent
    }
  } else {
    assert.eq(type(exponent), int, message: "Exponents need to be of integer type")
    additional-exponent = exponent
  }


  let preapplied-exponent = inline-exponent + additional-exponent
  let preapplied-factor = 1 / pow10(preapplied-exponent) / unit
  let ticks = ticks.map(x => (x - offset*unit) * preapplied-factor)

  
  let significant-digits = tick-info.at("significant-digits", default: none)
  if significant-digits == none {
    significant-digits = _estimate-significant-digits(ticks)
  } else {
    significant-digits += preapplied-exponent
  }
  
  let labels = ticks
   .map(calc.round.with(digits: significant-digits))
   .map(num.with(
     e: inline-exponent,
     digits: significant-digits
   )
  )


  if suffix != none {
    labels = ticks.zip(labels).map(((tick, label)) => {
      if tick == 0 { return $0$ }
      tick = calc.round(tick, digits: 3)

      if tick == 1 { label = none }
      else if tick == -1 { label = "−"}

      label + suffix
    })
  }


  (
    labels: labels, 
    exponent: additional-exponent, 
    offset: offset
  )
}


/// Formats logarithmic ticks, see @tick-locate.log. 
#let log(

  /// The ticks to format.
  /// -> array. 
  ticks,

  /// The base of the logarithm. 
  /// -> int | float
  base: 10,
  
  /// Whether to use a fixed exponent and which one. 
  /// -> auto | int
  exponent: auto, 

  auto-exponent-threshold: 3,
  round-exponent-digits: 4, 
  
  /// Which base to display with the ticks. If `auto`, the base is inferred 
  /// from `base`. 
  /// -> auto | content
  base-label: auto,

  /// Additional information from the tick locator. 
  /// -> dictionary
  tick-info: (:), 
  
  /// Arguments that are ignored by this formatter. 
  /// -> any
  ..args

) = {
  // Sometimes the log ticker resorts to linear ticking and then this is better
  if "linear" in tick-info and tick-info.linear {
    return linear(
      ticks, 
      tick-info: tick-info, 
      exponent: exponent, 
      auto-exponent-threshold, auto-exponent-threshold
    )
  }

  if base-label == auto { 
    if base == calc.e { base-label = $e$}
    else { base-label = base }
  }

  
  if exponent == auto {
    let num = num.with(omit-unit-mantissa: true, base: base-label, auto-e: false)

    ticks.map(x => 
      num(
        float.signum(x), 
        e: calc.round(calc.log(calc.abs(x), base: base), 
        digits: round-exponent-digits)
      )
    )
  } else {
    ticks.map(num)
  }
}





/// Formats symlog ticks, see @tick-locate.symlog. 
#let symlog(

  /// The ticks to format.
  /// -> array. 
  ticks,

  /// The base of the logarithm. 
  /// -> int | float
  base: 10,

  /// The threshold where the scale switches between linear and logarithmic. 
  /// -> float
  threshold: 1, 
  
  /// Whether to use a fixed exponent and which one. 
  /// -> auto | int
  exponent: auto, 

  auto-exponent-threshold: 3,
  round-exponent-digits: 4, 
  
  /// Which base to display with the ticks. If `auto`, the base is inferred 
  /// from `base`. 
  /// -> auto | content
  base-label: auto,

  /// Additional information from the tick locator. 
  /// -> dictionary
  tick-info: (:), 
  
  /// Arguments that are ignored by this formatter. 
  /// -> any
  ..args

) = {

  let upper-log = ticks.filter(tick => tick >= threshold or tick <= -threshold)

  let log = log(
    upper-log, 
    tick-info: tick-info, 
    base: base,
    base-label: base-label,
    exponent: exponent, 
    auto-exponent-threshold, auto-exponent-threshold
  )

  let linear = linear(
    ticks.filter(tick => tick < threshold and tick > -threshold)
  )

  log + linear.labels
}









#import "@preview/elembic:1.1.0" as e

#let datetime-smart-first = e.element.declare(
  "datetime-smart-first",
  prefix: "lilaq",

  display: it => {
    if type(it.body) == content { 
      return it.body
    }
    
    let format = it.at(it.key)
    if type(format) == str { it.body.display(format) }
    else { format(it.body) }
  },

  fields: (
    e.field("body", e.types.union(content, datetime), required: true),
    e.field("key", str, default: "month"),
    e.field("month", e.types.union(str, function), default: "[year]"),
    e.field("day", e.types.union(str, function), default: "[month repr:short]"),
    e.field("hour", e.types.union(str, function), default: "[month repr:short]-[day]"),
    e.field("minute", e.types.union(str, function), default: "[month repr:short]-[day]"),
    e.field("second", e.types.union(str, function), default: "[month repr:short]-[day]"),
  )
)



#let datetime-smart-format = e.element.declare(
  "datetime-smart-format",
  prefix: "lilaq",

  display: it => {

    if it.key == none {
      return it.datetime.display()
    } 

    let first = if it.key in ("month", "day") { 1 } else { 0 }

    let component = (
      "year": dt => false,
      "month": dt => dt.month() == 1,
      "day": dt => dt.day() == 1,
      "hour": dt => dt.hour() == 0,
      "minute": dt => dt.hour() == 0 and dt.minute() == 0,
      "second": dt => dt.hour() == 0 and dt.minute() == 0 and dt.second() == 0,
    ).at(it.key)

    if it.smart-first and component(it.datetime) and it.key != "year" {
      tick-datetime-smart-first(it.datetime, key: it.key)
    } else {
      let format = it.at(it.key)
      if type(format) == str { it.datetime.display(format) }
      else { format(it.datetime) }
    }
  },

  fields: (
    e.field("datetime", datetime, required: true),
    e.field("smart-first", bool, default: true),
    e.field("key", e.types.option(str), default: "month"),
    e.field("year", e.types.union(str, function), default: "[year]"),
    e.field("month", e.types.union(str, function), default: "[month repr:short]"),
    e.field("day", e.types.union(str, function), default: "[day]"),
    e.field("hour", e.types.union(str, function), default: "[hour]:[minute]"),
    e.field("minute", e.types.union(str, function), default: "[hour]:[minute]"),
    e.field("second", e.types.union(str, function), default: "[hour]:[minute]:[second]"),
  )
)


#let display-smart-offset = (it, smart-first: true) => {

  if it.key == none {
    return none
  }

  let format-by-key(datetime, key) = {
    let format = it.at(key)
    if type(format) == str { datetime.display(format) }
    else { format(datetime) }
  }

  let (first, .., last) = it.ticks

  if it.key == "month" {

    let has-no-first = first.month() != 1 or not smart-first
    if (first.year() == last.year() and has-no-first) or not it.avoid-redundant { 
      format-by-key(first, "year")
    }

  } else if it.key == "day" {

    let has-no-first = first.day() != 1 or not smart-first
    if (first.year() == last.year() and first.month() == last.month() and has-no-first) or not it.avoid-redundant   { 
      format-by-key(first, "month")
    } else if first.year() == last.year() { 
      format-by-key(first, "year")
    }

  } else if it.key in ("hour", "minute", "second") {
    
    if first.year() == 0 { return }
    
    let has-no-first = first.hour() != 0 or not smart-first
    if (first.year() == last.year() and first.month() == last.month() and first.day() == last.day() and has-no-first) or not it.avoid-redundant { 
      format-by-key(first, "day")
    } else if first.year() == last.year() { 
      format-by-key(first, "year")
    }

  }
}


#let datetime-smart-offset = e.element.declare(
  "datetime-smart-offset",
  prefix: "lilaq",

  display: it => e.get(e-get =>
    display-smart-offset(it, smart-first: e-get(datetime-smart-format).smart-first)
  ),

  fields: (
    e.field("ticks", e.types.array(datetime), required: true),
    e.field("avoid-redundant", bool, default: true),
    e.field("key", e.types.option(str), default: "month"),
    e.field("year", e.types.union(str, function), default: "[year]"),
    e.field("month", e.types.union(str, function), default: "[year]-[month repr:short]"),
    e.field("day", e.types.union(str, function), default: "[year]-[month repr:short]-[day]"),
  )
)




#let datetime(
  ticks,
  tick-info: (:), 
  format: datetime-smart-format,
  format-offset: datetime-smart-offset,
  min: 0,
  max: 1,
  ..args
) = {
  assert(
    "mode" in tick-info,
    message: "datetime can only be used with a datetime tick locator"
  )

  let key = tick-info.at("key", default: none)
  let datetimes = time.to-datetime(
    ..ticks, 
    mode: if key == none { tick-info.mode } else { "datetime" }
  )

  // let offset-datetime = if min > max {
  //   datetimes.first()
  // } else {
  //   datetimes.last()
  // }
  let offset = format-offset(datetimes, key: key)

  let labels = if type(format) == function {
    datetimes.map(dt => format(dt, key: key))
  } else if type(format) == str {
    datetimes.map(dt => dt.display(format))
  }

  (
    labels: labels, 
    exponent: 0, 
    offset: offset
  )
}

