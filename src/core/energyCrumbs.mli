open Data.Shared
open Utils.Primitives

type e = dots Doubleable.t
type t
type top

val origin     : t
val top        : t -> int * e
val item       : int -> t -> e
val maybe_item : int -> t -> e option
val exists     : int -> int -> t -> bool
val update_top : (top -> top) -> t -> t

module Top : sig
    val succ   : top -> top
    val pred   : top -> top
    val split  : top -> top
    val jump   : int -> top -> top
    val return : top -> top
  end
