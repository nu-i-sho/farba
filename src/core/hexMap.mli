module Coord : sig
  type t

  val zero    : t
  val compare : t -> t -> int
  val move    : Side.t -> t -> t
  end

include Map.S with type key := Coord.t
