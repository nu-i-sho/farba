type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val rev  : t -> t
val turn : Hand.t -> t -> t
