open Common

type e = | Command of command
         | OutOfRange of hand
type t

val make   : command list -> t
val length : t -> int
val get    : int -> t -> e
val set    : int -> command -> t -> t
