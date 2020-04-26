type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

val rev  : t -> t
val turn : Common.hand -> t -> t
