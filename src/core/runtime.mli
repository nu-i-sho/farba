module Make (Weaver : WEAVER.T) : sig
    type t

    val make : Weaver.t -> Solution.t -> t
    val mode : t -> RuntimeMode.t
    val weaver : t -> Weaver.t
    val solution : t -> Solution.t
    val call_stack_top : t -> Data.CallStackPoint.t
    val tick : t -> (TickStatus.t, t) Statused.t
      
  end
