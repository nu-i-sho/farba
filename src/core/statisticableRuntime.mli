module Make (Weaver : STATISTICABLE_WEAVER.T) : sig
    include STATISTICABLE_RUNTIME.T with type weaver_t = Weaver.t
    val make : weaver_t -> Solution.t -> t    
  end
