type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

include Map.OrderedType with type t := t

val count : int
val max   : t
val min   : t
val all   : t list
  
val succ  : t -> t
val pred  : t -> t
