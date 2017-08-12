module type T = sig
    type t

    val summary : t -> int    
    val runs    : t -> int
    val finds   : t -> int
    val returns : t -> int

  end
