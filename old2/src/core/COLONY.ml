module type T = sig 
    type t

    val height : t -> int
    val width  : t -> int
    val mem    : Index.t -> t -> bool
    val get    : Index.t -> t -> ColonyItem.t

  end
