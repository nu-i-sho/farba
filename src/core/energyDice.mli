type mode =
  | Find of Dots.t
  | Call 
  | Back
  | Stay

type die = Dots.t
type t
   
val origin    : t
val mode      : t -> mode
val top_index : t -> int
val top_dies  : t -> die list
val top_die   : t -> die
val dies      : int -> t -> die list
val die       : int -> t -> die
val maybe_die : int -> t -> die option

val with_mode : mode -> t -> t
val jump      : int -> t -> t
val step      : t -> t
val step_back : t -> t
val back      : t -> t
val succ      : t -> t
val pred      : t -> t
