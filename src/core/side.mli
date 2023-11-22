type t =
  | Up
  | LeftUp
  | LeftDown
  | Down
  | RightDown
  | RightUp

val opposite : t -> t
val turn     : Hand.t -> t -> t
