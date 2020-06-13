type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

include Map.OrderedType with type t := t

val load    : char Seq.t -> t * char Seq.t
val unload  : t -> char Seq.t
  
val count   : int
val all     : t list
val max     : t
val min     : t
  
val succ    : t -> t
val pred    : t -> t
