open Data

type t

val origin    : t
val top_mode  : t -> Die.mode
val top_index : t -> int
val top_dies  : t -> Die.energy list
val top_die   : t -> Die.energy
val dies      : int -> t -> Die.energy list
val die       : int -> t -> Die.energy
val maybe_die : int -> t -> Die.energy option

val with_top_mode : Die.mode -> t -> t
