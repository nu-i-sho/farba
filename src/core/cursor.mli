type t
   
val make     : Tissue.Coord.t -> Tissue.t -> t
val tissue   : t -> Tissue.t
val position : t -> Tissue.Coord.t
val perform  : Action.t -> t -> t
  
exception Clotted
exception Out_of_tissue
  
val is_out_of_tissue : t -> bool
val is_clotted       : t -> bool

