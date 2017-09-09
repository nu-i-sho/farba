type t

val make      : Pigment.t -> Side.t -> t
val pigment   : t -> Pigment.t
val gaze      : t -> Side.t
val is_cancer : t -> bool
val turn      : Common.hand -> t -> t
val inject    : Pigment.t -> t -> t
val replicate : Common.relation -> t -> t

  
