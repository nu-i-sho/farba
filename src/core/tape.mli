module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end

module Make (Commander : COMMANDER) : sig
  type t
  val make : Commander.t -> Source.t -> t
  end
