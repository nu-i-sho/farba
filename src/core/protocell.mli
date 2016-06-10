type t = Protocell.t

val first : t
val kind_of : t -> CellKind.t
val turn : Hand.t -> t -> t
val to_clot : t -> t
val inject : HelsPigment.t -> t -> t
val replicate : Relationship.t -> t -> t
