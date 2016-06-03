type t

val turn      : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> (t * t)
