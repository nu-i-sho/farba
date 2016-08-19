module Make (Weaver : STATISTICABLE_WEAVER.T) : sig
  module Subscribe (Observer : Contracts.CALL_STACK_OBSERVER.T) :
    sig include STATISTICABLE_RUNTIME.T
                with type weaver_t = Weaver.t
        val make : Observer.t -> Weaver.t -> Solution.t -> t
    end
  end
