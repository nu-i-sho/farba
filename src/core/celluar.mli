type t

val make : Nucleus.t -> t
val turn : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> (t * t)
