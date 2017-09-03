type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

exception Overflow
         
val max        : t
val min        : t
val all        : t list
val count      : int
val to_index   : t -> int
val of_index   : int -> t
val compare    : t -> t -> int
val succ       : t -> t
val pred       : t -> t
val cycle_succ : t -> t
val cycle_pred : t -> t


module Map   : Map.S with type key = t
