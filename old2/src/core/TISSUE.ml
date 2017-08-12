module type T = sig
    type t

    val get : Index.t -> t -> Shared.TissueItem.t
    val set : Index.t -> Shared.TissueItem.t -> t -> t
    val mem : Index.t -> bool
  end
