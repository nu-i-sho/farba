type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

include Map.OrderedType with type t := t
include IO.S with type t := t
  
val count : int
val all   : t list
val max   : t
val min   : t
  
val succ  : t -> t
val pred  : t -> t
