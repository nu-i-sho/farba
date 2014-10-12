module Make (Direction : DIRECTION.T) = sig
  type t

  val place_of     : t -> Place.t
  val direction_of : t -> Direction.t
  val fill_of      : t -> Fill.t 
  val do_with      : t -> command:Command.t -> t
end
