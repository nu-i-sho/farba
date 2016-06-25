module Extend (Runtime : RUNTIME.T) : sig
    
    include COUNTABLE_RUNTIME.T 
	    with type counter_t = RuntimeCounter.t

    val make : base:Runtime.t -> t
 
  end
