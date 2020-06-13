type t
   
val make             : Tissue.t -> t
val tissue           : t -> Tissue.t
val position         : t -> Tissue.Coord.t
val is_out_of_tissue : t -> bool
val is_clotted       : t -> bool
val perform          : Command.t -> t -> t
    
exception Clotted
exception Out_of_tissue
