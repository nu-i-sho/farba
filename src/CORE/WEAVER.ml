open Data

module type T = sig
    type tissue_t
    type t

    val tissue     : t -> tissue_t
    val stage      : t -> WeaverStage.t
    val turn       : Hand.t -> t -> t
    val move       : t -> t
    val pass       : t -> t
    val replicate  : Relation.t -> t -> t
    val statistics : t -> WeaverStatistics.t
end
