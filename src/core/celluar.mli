module Kind : sig
    type t = | Hels
	     | Clot
	     | Cancer
end

type t = private {   pigment : Pigment.t;
                        gaze : HexagonSide.t;
                   cytoplazm : Pigment.t option;
		 }

val first     : t 
val kind_of   : t -> Kind.t
val turn      : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> t

val replicate_to_cytoplazm : relationship : Relationship.t
	                  -> donor : t 
                          -> acceptor : HelsPigment.t
			  -> t

val replicate_to_celluar : relationship : Relationship.t
	                -> donor : t 
                        -> acceptor : t
	                -> (t * t)
