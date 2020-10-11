type e = (module LEVEL.S)
type t

val std     : t
val get     : int -> t -> e
val get_opt : int -> t -> e option 
