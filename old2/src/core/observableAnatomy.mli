module Observe (Anatomy : ANATOMY.T)
	      (Observer : Shared.ANATOMY_OBSERVER.T) : sig
 
   include ANATOMY.T
   val make :  anatomy : Colony.t 
	   -> observer : Observer.t 
	   -> t
  end
