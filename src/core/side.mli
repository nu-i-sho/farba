type t =
  | Up
  | LeftUp
  | RightUp
  | Down
  | LeftDown
  | RightDown
    
val rev     : t -> t
val turn    : Hand.t -> t -> t
val compare : t -> t -> int
val all     : t list       
