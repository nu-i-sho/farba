open Data.Shared
open Data.Tissue

module type T = sig
    type tissue
    type t

    val tissue    : t -> tissue
    val stage     : t -> WeaverStage.t
    val turn      : hand -> t -> t
    val move      : t -> t
    val pass      : t -> t
    val replicate : relation -> t -> t
  end
