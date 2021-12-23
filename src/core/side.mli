type t =
  | Up
  | LeftUp
  | RightUp
  | Down
  | LeftDown
  | RightDown
    
val opposite   : t -> t
val turn_right : t -> t
val turn_left  : t -> t
val turn       : Hand.t -> t -> t
val compare    : t -> t -> int
val all        : t list       
