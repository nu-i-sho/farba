module Make (Anatomy : ANATOMY.T) : sig 
    
    include TISSUE_CELL.T
    val make : anatomy : Anatomy.t 
            ->   first : Shared.Nucleus.Hels.t
	    ->   index : Index.t
            -> t option
  end
