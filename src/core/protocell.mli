module Kind : sig
    type t = | Hels
	     | Clot
	     | Cancer
end

type t = private {   pigment : Pigment.t;
                        gaze : HexagonSide.t;
                   cytoplasm : Pigment.t option;
		 }

include CELL.T with type t := t 
                and type rep_res_t := t  

val first   : t 
val kind_of : t -> Kind.t

val replicate_to_cytoplasm : relationship : Relationship.t
	                  -> donor : t 
                          -> acceptor : HelsPigment.t
			  -> t

val replicate_to_protocell : relationship : Relationship.t
	                  -> donor : t 
                          -> acceptor : t
	                  -> (t * t)
