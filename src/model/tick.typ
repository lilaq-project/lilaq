/// A tick on a diagram axis. 
/// TODO: Not used yet

#let tick-label(

) = {}


/// A tick on a diagram axis. 
#let tick(
  
  /// Position of the tick in data coordinates. 
  /// -> float
  pos, 

  /// Tick label. 
  /// -> any
  label: none,

  /// Stroke of the tick. If set to `auto`, the stroke is inherited the axis spine. 
  /// -> auto | stroke
  stroke: auto,

  /// Length of the tick outside the diagram. 
  /// -> length
  outside: 0pt,
  
  /// Length of the tick inside the diagram. 
  /// -> length
  inside: 4pt
  
) = (
  pos: pos,
  label: label,
  stroke: stroke,
  outside: outside,
  inside: inside,
)