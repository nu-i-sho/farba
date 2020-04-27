type t

module Coord : sig
  type t
     
  val move    : Side.t -> t -> t
  val compare : t -> t -> int
  end

val empty          : t

val is_in          : Coord.t -> t -> bool
val is_out_of      : Coord.t -> t -> bool
val has_clot       : t -> bool
  
val clot           : t -> Coord.t 
val clot_opt       : t -> Coord.t option
val cytoplasm      : Coord.t -> t -> Pigment.t
val cytoplasm_opt  : Coord.t -> t -> Pigment.t option
val nucleus        : Coord.t -> t -> Nucleus.t
val nucleus_opt    : Coord.t -> t -> Nucleus.t option
  
val set_nucleus    : Coord.t -> Nucleus.t -> t -> t
val remove_nucleus : Coord.t -> t -> t
val set_clot       : Coord.t -> t -> t
val remove_clot    : t -> t
