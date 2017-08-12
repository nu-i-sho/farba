module type T = sig
    type t

    val height     : t -> int
    val width      : t -> int
    val mem        : Index.t -> t -> bool
    val set        : Index.t -> AnatomyItem.In.t -> t -> t
    val get        : Index.t -> t -> AnatomyItem.Out.t
    val colony_get : Index.t -> t -> Shared.ColonyItem.t
    val tissue_get : Index.t -> t -> Shared.TissueItem.t

  end
