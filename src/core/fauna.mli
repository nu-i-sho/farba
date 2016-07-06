type t = Data.Nucleus.t

val turn      : Hand.t -> t -> t
val inject    : Pigment.t -> t -> t
val replicate : Data.Relation.t -> Pigment.t -> t -> t 
