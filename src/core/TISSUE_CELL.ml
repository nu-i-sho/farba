module type T = sig
    type t

    val first : Colony.t -> Index.t -> t option
    val kind_of : t -> CellKind.t
    val is_out : t -> bool
    val turn : Hand.t -> t -> t
    val replicate : Relationship.t -> t -> t
  
  end
