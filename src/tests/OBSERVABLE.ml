module type T = sig
  type 'a t
  type 'a observer_t
  type subscribtion_t
  
  val subscribe : 'a observer_t -> 'a t -> subscribtion_t
  val unsubscribe : subscribtion_t -> 'a t -> 'a observer_t
end

module type MAKE_T = functor 
    (Observer : OBSERVER.T) -> 
      T with type 'a observer_t = 'a Observer.t
