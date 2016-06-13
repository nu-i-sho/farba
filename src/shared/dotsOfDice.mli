type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

include Map.OrderedType with type t := t 

val increment : t -> t
val decrement : t -> t
val opposite  : t -> t
val min       : t -> t -> t
val max       : t -> t -> t
