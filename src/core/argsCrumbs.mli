open Data.Shared

type e = args
type t

val of_string : string -> t
val try_get   : int -> t -> e option
val remove    : int -> t -> t
val put       : int -> e -> t -> t
