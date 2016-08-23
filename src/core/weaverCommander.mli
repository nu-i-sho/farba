module Make (Weaver : WEAVER.T) : sig
    type t = Weaver.t
    val do' : Data.Action.t -> t -> (TickStatus.t, t) Statused.t
  end
