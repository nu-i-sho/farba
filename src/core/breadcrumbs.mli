module Event : sig
    type t = private | New   (Dots.t * int)
		     | Move  (Dots.t * int * int) 
		     | Split (Dots.t * Dots.t * Dots.t * int)
		     | Marge (Dots.t * Dots.t * Dots.t * int)
end

type t 

val start      : t
val starto     : (BreadcrumbsEvent.t -> unit) -> t
val last       : t -> DotsOfDice.t * int
val last_crumb : t -> DotsOfDice.t
val last_place : t -> int
val count      : t -> int
val length     : t -> int
val increment  : t -> t
val decrement  : t -> t
val split      : t -> t
