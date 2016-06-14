module type T = sig
    type t 

    val start      : t
    val last       : t -> DotsOfDice.t
    val last_place : t -> int
    val is_empty   : t -> bool
    val count      : t -> int
    val length     : t -> int
    val increment  : t -> t
    val decrement  : t -> t
    val split      : t -> t

  end
