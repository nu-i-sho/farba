module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end

module Make (Commander : COMMANDER) : sig
  type t
  val make : Commander.t -> Statement.t list -> t
  val step : t -> t option
  end
