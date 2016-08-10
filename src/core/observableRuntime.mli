module Make (Weaver : STATISTICABLE_WEAVER.T) : sig
    module Subscribe (Observer : T.CALL_STACK_OBSERVER) : sig
        include STATISTICABLE_RUNTIME.T
                with type weaver_t = Weaver.t
        val make : Observer.t -> Weaver.t -> Solution.t -> t
      end
  end
