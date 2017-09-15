type t

module Coord : sig
    type t
    val move : Side.t -> t -> t  
  end
   
val height          : t -> int
val width           : t -> int
val in_range        : Coord.t -> t -> bool
val out_of_range    : Coord.t -> t -> bool
val clot            : t -> Coord.t option
val cytoplasm       : Coord.t -> t -> Pigment.t
val nucleus         : Coord.t -> t -> Nucleus.t
val maybe_cytoplasm : Coord.t -> t -> Pigment.t option
val maybe_nucleus   : Coord.t -> t -> Nucleus.t option
val set_nucleus     : Coord.t -> Nucleus.t -> t -> t
val remove_nucleus  : Coord.t -> t -> t
val set_clot        : Coord.t -> t -> t
