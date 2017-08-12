open Utils.Primitives
open Data.Shared

module Crumbs : sig
    type t
    type e = int * (dots Doubleable.t)

    val head       : t -> e
    val mayby_item : int -> t -> e option
    val exists     : int -> int -> t -> bool
    val as_list    : t -> e list
  end
   
type t

val origin : t
val jump   : int -> t -> t
val step   : t -> t
val back   : t -> t
val succ   : t -> t
val pred   : t -> t
val crumbs : t -> Crumbs.t

val limit        : int -> t -> t
val is_left_out  : t -> bool
val is_right_out : t -> bool
val is_out       : t -> bool

