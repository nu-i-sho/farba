type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val opposite : t -> t
val turn : to':HandSide.t -> t -> t
