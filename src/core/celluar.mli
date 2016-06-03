type t

module Kind : sig
    type t = | Hels
	     | Clot
	     | Cancer
end

module State : sig
    type t = 
      private {    pigment : Pigment.t;
                      gaze : HexagonSide.t;
                 cytoplazm : Pigment.t option;
	        has_spirit : bool;
	              kind : Kind.t
	      }
  end

val first     : Command.t array -> t
val state_of  : t -> State.t 
val turn      : HandSide.t -> t -> t
val replicate : Relationship.t -> t -> (t * t)

val replicate_to_cytoplazm : Relationship.t
	                  -> donor : t 
                          -> acceptor : HelsPigment.t
			  -> (t * t)

val replicate_to_celluar : Relationship.t
	                -> donor : t 
                        -> acceptor : t
	                -> (t * t)
