type t

module Turn = sig
  type t
end

val left   : t -> t
val right  : t -> t
val mirror : t -> t
val turn   : t -> Turn.t -> t
val x      : t -> int -> int
val y      : t -> int -> int
