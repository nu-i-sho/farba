module Dots = DotsOfDice

module Event : sig
    type t = private | Create of Dots.t * int
                     | Move   of Dots.t * int * int 
                     | Split  of Dots.t * Dots.t * Dots.t * int
		     | Marge  of Dots.t * Dots.t * Dots.t * int
end

type t 

val start      : t
val starto     : observer:(Event.t -> unit) -> t
val last       : t -> Dots.t * int
val last_crumb : t -> Dots.t
val last_place : t -> int
val count      : t -> int
val length     : t -> int
val increment  : t -> t
val decrement  : t -> t
val split      : t -> t
