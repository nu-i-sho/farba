module Merge (Colony : COLONY.T) 
	     (Tissue : TISSUE.T)
           (Observer : T.ANATOMY_OBSERVER) : sig

    include ANATOMY.T
    val make :   colony : Colony.t
	    -> observer : Observer.t
	    -> t
end
