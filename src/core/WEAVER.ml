module type T = sig
    type t

    val tissue    : t -> Tissue.t
    val turn      : Data.Hand.t -> t -> t
    val move      : t -> (MoveStatus.t, t) Statused.t
    val pass      : t -> (PassStatus.t, t) Statused.t
    val replicate : Data.Relation.t -> t
                 -> (MoveStatus.t, t) Statused.t
end

