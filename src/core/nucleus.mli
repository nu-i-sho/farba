type t

val pigment     : t -> Pigment.t
let spirit      : t -> Virus.t
let with_spirit : Virus.t -> t -> t
val is_cancer   : t -> bool
val turn        : HandSide.t -> t -> t
val replicate   : Relationship.t -> t -> (t * t)
