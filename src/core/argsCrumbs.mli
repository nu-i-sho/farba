open Utils.Primitives
open Data.Shared

type e = | Active of args
         | Static of args
                   
type active
type t

val active        : t -> (int * args) option
val activate      : int -> t -> t
val item          : int -> t -> e
val maybe_item    : int -> t -> e option
val of_string     : string -> t
val update_active : (active -> active) -> t -> t
  
module Active : sig
    val succ : active -> active
    val pred : active -> active
    val jump : int -> active -> active
  end
