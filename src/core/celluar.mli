type t

val make              : Nucleus.t -> t
let nucleus_pigment   : t -> Pigment.t
val cytoplazm_pigment : t -> Pigment.t
val is_cancer         : t -> bool
val turn              : HandSide.t -> t -> t
val replicate         : Relationship.t -> t -> (t * Nucleus.t)
