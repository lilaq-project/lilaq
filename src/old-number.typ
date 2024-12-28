#let sequence-constructor = $$.body.func()

#let get-decimal-pos(str, decimal-marker) = {
  let decimal-pos = str.position(decimal-marker)
  if decimal-pos == none { decimal-pos = str.len() }
  return decimal-pos
}
#let get-num-decimals(str, decimal-marker) = {
  let decimal-pos = str.position(decimal-marker)
  if decimal-pos != none { return str.len() - decimal-pos - 1 }
  return 0
}

#let make-digit-grouping(input, group-size, group-sep, group-min-digits, decimal-marker) = {
  let decimal-pos = get-decimal-pos(input, decimal-marker)
  let effective-group-size = group-size
  if decimal-pos < group-min-digits {
    effective-group-size = group-min-digits
  }
  let index = effective-group-size - calc.rem(decimal-pos, effective-group-size)
  let result = ""
  let i = 0
  for k in input {      
    if k == decimal-marker { 
      effective-group-size = group-size
      if input.len() - decimal-pos <= group-min-digits {
        effective-group-size = group-min-digits
      }
      index = effective-group-size - 1
      i = -1 
    } else if calc.rem(index, effective-group-size) == 0 and i != 0 {
      result += group-sep 
    }
    result += k
    index += 1
    i += 1
  }
  return result
}


/// Formats a number.
///
/// - number (float, integer, content): The number to format.
/// - e (integer): Exponent (optional). The exponent is applied to both the
///            number and the uncertainty (pm) - if given. 
/// - pm (float, integer, content): Uncertainty of the value. 
/// - digits (auto, integer): Force a given number of digits. Adds zeros if this is greater than the number of digits in the number and truncates the number if it is less. This value cannot be negative. 
/// - times (content): Symbol to use between number and factor 10^...
/// - decimal-marker (string): The decimal marker used in the output is controlled with this parameter. 
/// - group-digits (boolean): Whether to group digits in long numbers. 
/// - group-size (integer): The size of digit groups. 
/// - group-sep (integer): The separator to use between digit groups. 
/// - implicit-plus: If set to true, also the + sign is shown. 
/// - tight: Enables tight typesetting (reduces spacing before and after the times and plus-minus symbol). 
#let num(
  number,
  e: none, 
  pm: none,
  digits: auto,
  times: sym.dot,
  decimal-marker: ".",
  group-digits: true,
  group-size: 3,
  group-sep: sym.space.thin,
  group-min-digits: 5,
  pmmode: "separate",
  implicit-plus: false,
  tight: false,
  base: 10
  // ..options
) = {
  assert(group-size > 0, message: "The group size needs to be greater than 0")
  let num-str
  if number == none {
    num-str = none
  } else {
    num-str = str(number)
    num-str = num-str.replace(",", decimal-marker)
    num-str = num-str.replace(".", decimal-marker)
    let sign = none
    if num-str.starts-with("-") or num-str.starts-with("−") {
      sign = $-$
      num-str = num-str.trim("-").trim("−")
    }
  
    let decimal-pos = get-decimal-pos(num-str, decimal-marker)
    
    if pm != none {
      pm = get-num-str(pm, decimal-marker)
      let num-decimals = get-num-decimals(num-str, decimal-marker)
      let num-decimals-pm = get-num-decimals(pm, decimal-marker)
  
      if num-decimals < num-decimals-pm {
        if num-decimals == 0 and not num-str.ends-with(".") { num-str += decimal-marker}
        num-str += "0" * (num-decimals-pm - num-decimals)
      } else if num-decimals > num-decimals-pm {
        if num-decimals-pm == 0 and not pm.ends-with(".") { pm += decimal-marker}
        pm += "0" * (num-decimals - num-decimals-pm)
      } 
      
      if group-digits {
        pm = group-digits(pm, group-size, group-sep, group-min-digits, decimal-marker)
      }
    }

    if digits != auto {
      let num-decimals = get-num-decimals(num-str, decimal-marker)
      if digits > num-decimals {
        if num-decimals == 0 and not num-str.ends-with(".") { num-str += decimal-marker}
        num-str += "0" * (digits - num-decimals)
      }
    }
    if group-digits {
      num-str = make-digit-grouping(num-str, group-size, group-sep, group-min-digits, decimal-marker)
    }
    
    if implicit-plus and sign == none {
      sign = $+$
    }
    num-str = $#sign#num-str$
  }
  
  

  
  
  let power = if e == none { none } else { 
    if tight { $#h(0pt)#times#h(0pt)#base^#e$ }
    else { $#times 10^#e$ }
  }
  
  number = num-str
  if pm != none {
    if type(pm) in ("float", "integer") { pm = $#str(pm)$ }
    if type(number) in ("float", "integer") { number = $#str(number)$ }
    let pmspacing = if tight { none } else { sym.space.thin }
    number = number + pmspacing + sym.plus.minus + pmspacing + pm
    if power != none { number = $(number)$}
  }
  
  // $#number$
  // number + power
  $#number#power$
}

#let num(
  number,
  e: none, 
  pm: none,
  digits: auto,
  times: sym.dot,
  decimal-marker: ".",
  group-digits: true,
  group-size: 3,
  group-sep: sym.space.thin,
  group-min-digits: 5,
  tight: false,
  omit-unit-mantissa: false,
  implicit-plus: false,
  base: 10,
  // ..options
) = {
  assert(group-size > 0, message: "The group size needs to be greater than 0")

  let elements = ()
  
  let num-str
  if number == none {
    num-str = none
  } else {
    num-str = str(number).replace(",", decimal-marker).replace(".", decimal-marker)
    let sign = none
    if num-str.starts-with("-") or num-str.starts-with("−") {
      sign = sym.minus
      num-str = num-str.trim("-").trim("−")
    }
  
    let decimal-pos = get-decimal-pos(num-str, decimal-marker)
    
    if pm != none {
      pm = str(pm).replace(",", decimal-marker).replace(".", decimal-marker)
      let num-decimals = get-num-decimals(num-str, decimal-marker)
      let num-decimals-pm = get-num-decimals(pm, decimal-marker)
  
      if num-decimals < num-decimals-pm {
        if num-decimals == 0 and not num-str.ends-with(".") { num-str += decimal-marker}
        num-str += "0" * (num-decimals-pm - num-decimals)
      } else if num-decimals > num-decimals-pm {
        if num-decimals-pm == 0 and not pm.ends-with(".") { pm += decimal-marker}
        pm += "0" * (num-decimals - num-decimals-pm)
      } 
      
      if group-digits {
        pm = make-digit-grouping(pm, group-size, group-sep, group-min-digits, decimal-marker)
      }
    }

    if digits != auto {
      digits = calc.max(0, digits)
      let num-decimals = get-num-decimals(num-str, decimal-marker)
      if digits > num-decimals {
        
        if num-decimals == 0 and not num-str.ends-with(".") { num-str += decimal-marker}
        num-str += "0" * (digits - num-decimals)
      } else if digits < num-decimals {
        if digits == 0 { digits -= 1 } // account for decimal marker
        num-str = num-str.slice(0, digits - num-decimals)
      }
    }
    if group-digits {
      num-str = make-digit-grouping(num-str, group-size, group-sep, group-min-digits, decimal-marker)
    }
    
    if implicit-plus and sign == none {
      sign = sym.plus
    }
    if sign != none {
      elements.push(sign)
    }
    elements.push(num-str)
  }

  let omit-mantissa = omit-unit-mantissa and number == 1 and pm == none
  if omit-mantissa {
    elements = ()
  }
  
  number = num-str
  if pm != none {
    if type(pm) in ("float", "integer") { pm = $#str(pm)$ }
    if tight { elements.push(h(0pt)) }
    elements.push(sym.plus.minus)
    if tight { elements.push(h(0pt)) }
    elements.push(pm)
    if e != none { 
      elements.insert(0, "(")
      number = $(number)$
      elements.push(")")
    }
  }

  
  let power = if e == none { none } else { 
    if not omit-mantissa {
      if tight { elements.push(h(0pt)) }
      elements.push(times)
      if tight { elements.push(h(0pt)) }
    }
    elements.push(math.attach([#base], t: [#e]))
  }
  
  math.equation(sequence-constructor(elements))
}

#let make-equation(..children) = math.equation(sequence-constructor(children.pos()))

#assert.eq(num(0), make-equation([0]))
#assert.eq(num(2.3), make-equation([2.3]))
#assert.eq(num(-2.3), make-equation(sym.minus, [2.3]))

// Implicit plus
#assert.eq(num(2.3, implicit-plus: true), make-equation(sym.plus, [2.3]))
#assert.eq(num(-2.3, implicit-plus: true), make-equation(sym.minus, [2.3]))


// Exponents and times
#assert.eq(num(2.3, e: 2), make-equation([2.3], sym.dot, math.attach([10], t: [2])))
#assert.eq(num(2.3, e: -22), make-equation([2.3], sym.dot, math.attach([10], t: sym.minus + "22")))
#assert.eq(num(2.3, e: 2, times: sym.times), make-equation([2.3], sym.times, math.attach([10], t: [2])))
#assert.eq(num(2.3, e: 2, tight: true), make-equation([2.3], h(0pt), sym.dot, h(0pt), math.attach([10], t: [2])))


// Change decimal marker
#assert.eq(num(2.3, decimal-marker: ","), make-equation([2,3]))


// None/NaN
#assert.eq(num(none), math.equation([]))
#assert.eq(num(float.nan), make-equation([NaN]))


// Digit grouping
#assert.eq(num(1000), make-equation("1000"))
#assert.eq(num(10000), make-equation("10" + sym.space.thin + "000"))
#assert.eq(num(100000), make-equation("100" + sym.space.thin + "000"))
#assert.eq(num(1000000000), make-equation("1" + sym.space.thin + "000" + sym.space.thin + "000"+ sym.space.thin + "000"))
#assert.eq(num(0.001), make-equation("0.001"))
#assert.eq(num(0.0001), make-equation("0.0001"))
#assert.eq(num(0.00001), make-equation("0.000" + sym.space.thin + "01"))
#assert.eq(num(1000000000.02232), make-equation("1" + sym.space.thin + "000" + sym.space.thin + "000"+ sym.space.thin + "000.022" + sym.space.thin + "32"))

#assert.eq(num(100000, group-digits: false), make-equation("100000"))
#assert.eq(num(100000.0002, group-digits: false), make-equation("100000.0002"))

#assert.eq(num(10000.00001, group-sep: "'"), make-equation("10'000.000'01"))
#assert.eq(num(10000.00001, group-size: 2, group-sep: "'"), make-equation("1'00'00.00'00'1"))
#assert.eq(num(1000, group-size: 2, group-sep: "'"), make-equation("1000"))
#assert.eq(num(1000, group-size: 2, group-sep: "'", group-min-digits: 2), make-equation("10'00"))


// Uncertainty
#assert.eq(num(2, pm: 1), make-equation([2], sym.plus.minus, [1]))
#assert.eq(num(2.223, e: 2, pm: 1), make-equation([(], [2.223], sym.plus.minus, [1.000], [)], sym.dot, math.attach([10], t: [2])))
#assert.eq(num(2, e: 2, pm: 0.11), make-equation([(], [2.00], sym.plus.minus, [0.11], [)], sym.dot, math.attach([10], t: [2])))


// Manual digits
#assert.eq(num(2, digits: 2), make-equation([2.00]))
#assert.eq(num(2, digits: 0), make-equation([2]))
#assert.eq(num(2, digits: -2), make-equation([2]))
#assert.eq(num(2.2343, digits: 0), make-equation([2]))
#assert.eq(num(2.2343, digits: 1), make-equation([2.2]))
#assert.eq(num(2.2343, digits: 2), make-equation([2.23]))
#assert.eq(num(2.2343, digits: 3), make-equation([2.234]))
#assert.eq(num(2.2343, digits: 4), make-equation([2.2343]))
#assert.eq(num(2.2343, digits: 10, group-digits: false), make-equation([2.2343000000]))
#assert.eq(num(2.564, digits: 0), make-equation([2]))

#let basic-examples = (
  0,
  0.0,
  1.2, 
  -1.2, 
  none,
  float.nan,
  arguments(1.2, e: 2),
  arguments(1.2, e: -22),
  1000,
  10000,
  0.0001,
  0.001,
)

#let more-examples = (
  arguments(2, implicit-plus: true),
  arguments(-2, implicit-plus: true),
  arguments(1.2, e: 2, times: sym.times),
  arguments(1.2, e: 2, tight: true),
)

#let uncertainty-examples = (
  arguments(2, pm: 1),
  arguments(2.223, e: 2, pm: 1),
  arguments(2., e: 2, pm: 0.11),
)

#let digits-examples = (
  arguments(2, digits: -2),
  arguments(2.2343, digits: 0),
  arguments(2.2343, digits: 1),
  arguments(2.2343, digits: 2),
  arguments(2.2343, digits: 3),
  arguments(2.2343, digits: 4),
  arguments(2.2343, digits: 10, group-digits: false),
  arguments(2.564, digits: 0),
)


#let show-examples(examples) = table(columns: examples.len(),
  ..examples.map(repr),
  ..examples.map(x => if type(x) == arguments { num(..x) } else { num(x) })
)

#set text(9pt)
#show-examples(basic-examples)
#show-examples(more-examples)
#show-examples(uncertainty-examples)
#show-examples(digits-examples)


