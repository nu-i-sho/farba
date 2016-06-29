module Make (Anatomy : ANATOMY.T) : sig
    
    include ACTIVE_CELL.T with type anatomy_t := Anatomy.t
    val make : anatomy : Anatomy.t
	    ->   index : int * int
            -> nucleus : Nucleus.t
	    -> out_t
  end
