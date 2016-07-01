module Merge (Colony : COLONY.T) 
             (Tissue : TISSUE.T) : sig

    include ANATOMY.T
    val make : Colony.t -> t
  end
