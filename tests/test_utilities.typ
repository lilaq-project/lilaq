#let match-type(value, ..args) = {
  let value-type = str(type(value))
  args = args.named()
  let get-output(output) = {
      if type(output) == function { return output() }
      else { return output }
    }
  for (key, output) in args {
    if key == "auto-type" { key = "auto" }
    if key == "none-type" { key = "none" }
    if value-type == key { 
      return get-output(output)
    }
  }
  if "default" in args { return get-output(args.default) }
  panic("The provided value matches none of the given types")
}


#let foo(arg) = {
  let processed-arg = match-type(
    arg,
    color: arg, 
    ratio: () => luma(arg), // lazy evaluation of result
    array: () => arg.map(x => 
      gradient.linear(..color.map.viridis).sample(x * 1%)
    ),
    default: black // if no default given and no match: panic
  )
  processed-arg
}
#foo(255%)
#foo((1, 100))