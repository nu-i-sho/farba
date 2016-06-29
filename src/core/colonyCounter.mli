module Make (Colony : COLONY.T) : sig
    type t
	   
    val calculate : Colony.t -> t
    val count_of  : Pigment.t -> t -> int
    val count     : t -> int
  
  end
