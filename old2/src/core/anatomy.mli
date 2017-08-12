module Merge (Colony : COLONY.T) 
             (Tissue : TISSUE.T) : sig
 
    include ANATOMY.T
    val merge : colony : Colony.t 
             -> tissue : Tissue.t
             -> t
  end
