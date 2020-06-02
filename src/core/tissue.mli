type t

module Coord : sig
  type t = private (int * int)
  module Map : Map.S with type key = t
  val move : Side.t -> t -> t
  end

val empty          : t

val is_in          : Coord.t -> t -> bool
val is_out_of      : Coord.t -> t -> bool
val has_clot       : t -> bool
  
val clot           : t -> Coord.t 
val clot_opt       : t -> Coord.t option
val cytoplasm      : Coord.t -> t -> Pigment.t
val cytoplasm_opt  : Coord.t -> t -> Pigment.t option
val cytoplasms     : t -> (Coord.t * Pigment.t) Seq.t
val nucleus        : Coord.t -> t -> Nucleus.t
val nucleus_opt    : Coord.t -> t -> Nucleus.t option
val nucleuses      : t -> (Coord.t * Nucleus.t) Seq.t 
  
val set_nucleus    : Coord.t -> Nucleus.t -> t -> t
val remove_nucleus : Coord.t -> t -> t
val add_cytoplasm  : Coord.t -> Pigment.t -> t -> t
val set_clot       : Coord.t -> t -> t
val remove_clot    : t -> t
