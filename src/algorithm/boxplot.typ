#import "../math.typ": percentile
#import "../assertations.typ"

/// Computes values needed for drawing a boxplot of a dataset. 
#let boxplot-statistics(

  /// Array of data values or dictionary with pre-computed boxplot statistics
  /// (required keys `"median"`, `"q1"`, `"q3"`, `"whisker-low"`, 
  /// `"whisker-high"` and optional keys `"outliers"`, `"mean"`). 
  /// -> array | dictionary
  input, 

  /// How to scale whiskers in terms of the interquartile range. 
  /// -> float
  whiskers: 1.5

) = {

  if type(input) == array {
    import "@preview/komet:0.1.0"
    return komet.boxplot(input, whisker-pos: whiskers)
  }

  assert(
    type(input) == dictionary,
    message: "Boxplot data either needs to be an array of values or a dictionary specifying boxplot statistics, got " + repr(input)
  )
  

  assertations.assert-dict-keys(
    input, 
    mandatory: ("median", "q1", "q3", "whisker-low", "whisker-high"),
    optional: ("outliers", "mean"),
    missing-message: key => "Boxplot data needs to specify \"" + key + "\"",
    unexpected-message: (key, possible-keys) => "Boxplot data contains unexpected key \"" + key + "\" (expected " + possible-keys + ")"
  )
  
  if not "outliers" in input {
    input.outliers = ()
  }

  input
}
