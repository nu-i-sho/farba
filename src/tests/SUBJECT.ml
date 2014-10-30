module type MAKE_T = functor 
    (Observer : OBSERVER.T) -> functor
      (Observable : OBSERVABLE.T with type 'a observer_t = 'a Observer.t) -> sig
	module type IN_T = module type of Observer
	module type OUT_T = module type of Observable
	module In : IN_T
	module Out : OUT_T
      end
