type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val of_char  : char -> t
val opposite : t -> t
val turn     : hand -> t -> t
