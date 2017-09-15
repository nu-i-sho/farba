type t

val make     : Tissue.Coord.t -> Tissue.t -> t
val is_in    : Tissue.Coord.t -> t -> bool
val tissue   : t -> Tissue.t
val position : t -> Tissue.Coord.t
val act      : Common.action -> t -> t
  
exception Tissue_is_clotted
exception Out_of_tissue
  
val is_out_of_tissue : t -> bool
val tissue_is_cloted : t -> bool

