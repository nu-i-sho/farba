open Data.Shared

module Crumbs : sig
    type t
    type e = int * dots

    val head    : t -> e
    val try_get : int -> t -> e option
    val exists  : int -> int -> t -> bool
    val to_list : t -> e list
  end
   
type t

val origin : t
val jump   : int -> t -> t
val step   : t -> t
val back   : t -> t
val succ   : t -> t
val pred   : t -> t

val limit        : int -> t -> t
val is_left_out  : t -> bool
val is_right_out : t -> bool
val is_out       : t -> bool

val attach     : args -> t -> t
val attachment : t -> args option
val detach     : t -> t
  
val crumbs : t -> Crumbs.t
