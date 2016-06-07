type t

val first : Set.t -> Set.Index.t -> t option
val kind_of : t -> CellKind.t
val is_out : t -> bool
val turn : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> t
