type t

val get : Index.t -> t -> TissueItem.t
val set : Index.t -> TissueItem.t -> t -> t
val empty : t
