type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val opposite : t -> t
val turn     : Hand.t -> t -> t