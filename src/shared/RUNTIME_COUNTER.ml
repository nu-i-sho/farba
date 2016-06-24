module type T = sig
    type t

    val zero    : t
    val summary : t -> int    
    val runs    : t -> int
    val finds   : t -> int
    val returns : t -> int

    val increment_runs    : t -> t
    val increment_finds   : t -> t
    val increment_returns : t -> t
	   
  end
