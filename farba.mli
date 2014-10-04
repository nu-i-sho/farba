module Make(Dir : Idir.T) = sig
  type t

  val place     : t -> Place.t
  val direction : t -> Dir.t
  val fill      : t -> Fill.t 
  val go        : t -> Command.t -> t
end
