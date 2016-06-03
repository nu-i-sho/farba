type t

val make    : Pigment.t -> t
val clot    : t
val pigment : t -> Pigment.t
val is_clot : t -> bool
