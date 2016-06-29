module type T = sig
    type t
	   
    val height : t -> int
    val width  : t -> int
    val get    : (int * int) -> t -> Pigment.t
  end
