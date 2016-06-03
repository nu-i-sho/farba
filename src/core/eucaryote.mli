type t = | Nucleus of Nucleus.t
         | Celluar of Celluar.t
	 | Cancer

val turn      : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> (t * t)
