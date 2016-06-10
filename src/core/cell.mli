type t

val first : Tissue.t -> Index.t -> t option
val kind_of : t -> CellKind.t
val is_out : t -> bool
val turn : Shared.Hand.t -> t -> t
val replicate : Relationship.t -> t -> t
