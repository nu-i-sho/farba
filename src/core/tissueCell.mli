module Make (Tissue : TISSUE.T) : sig 
    
    include TISSUE_CELL.T
    val make : Tissue.t -> Index.t -> t option
  
  end
