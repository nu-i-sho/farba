module Coord : sig
  type t = private int * int
                 
  val none    : t
  val is_none : t -> bool
  val move    : Side.t -> t -> t
  module Map  : Map.S with type key = t
  end

type t =
  private { cytoplasms : Pigment.t Coord.Map.t;
             nucleuses : Nucleus.t Coord.Map.t;
                  clot : Coord.t;
                cursor : Coord.t
          }

val empty          : t
val is_in          : Coord.t -> t -> bool
val is_out_of      : Coord.t -> t -> bool
val cytoplasm      : Coord.t -> t -> Pigment.t
val cytoplasm_opt  : Coord.t -> t -> Pigment.t option
val nucleus        : Coord.t -> t -> Nucleus.t
val nucleus_opt    : Coord.t -> t -> Nucleus.t option
val has_clot       : t -> bool
val clot           : t -> Coord.t
val cursor         : t -> Coord.t

val set_nucleus    : Coord.t -> Nucleus.t -> t -> t
val remove_nucleus : Coord.t -> t -> t
val set_clot       : Coord.t -> t -> t
val remove_clot    : t -> t
val set_cursor     : Coord.t -> t -> t

include IO.S with type t := t
