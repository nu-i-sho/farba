module Make (Weaver : WEAVER.T) : sig
    include RUNTIME.T with type weaver_t =  Weaver.t
    val make : weaver_t -> Solution.t -> t
  end
