type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val opposite : t -> t
val turn     : Hand.t -> t -> t
val index_of : t -> int 
