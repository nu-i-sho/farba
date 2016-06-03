type t

val make       : Pigment.t -> t
val pigment_of : t -> Pigment.t
val is_clot    : t -> bool
