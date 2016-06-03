type t 

val start      : t
val last       : t -> DotsOfDice.t * int
val last_crumb : t -> DotsOfDice.t
val last_place : t -> int
val count      : t -> int
val length     : t -> int
val increment  : t -> t
val decrement  : t -> t
val multiply   : t -> t
