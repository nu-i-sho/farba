type t

val make              : Nucleus.t -> t
val nucleus_pigment   : t -> Pigment.t
val cytoplazm_pigment : t -> Pigment.t
val spirit            : t -> Virus.t
val with_spirit       : Virus.t -> t -> t 
val is_cancer         : t -> bool
val turn              : HandSide.t -> t -> t
val replicate         : Relationship.t -> t -> (t * Nucleus.t)
