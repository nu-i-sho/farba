type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

val increment : t -> t
val decrement : t -> t
val opposite  : t -> t
val left      : t -> t
val right     : t -> t
val min       : t -> t -> t
val max       : t -> t -> t
