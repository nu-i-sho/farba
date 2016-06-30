module type T = sig
    
    type t
    type anatomy_t
    type out_t = | Cell of t
                 | Clot of anatomy_t
	         | Out  of anatomy_t
 
    val turn      : Hand.t -> t -> t
    val move      : t -> out_t
    val replicate : Data.Relation.t -> t -> out_t
    val index     : t -> (int * int)
    val anatomy   : t -> anatomy_t

  end
