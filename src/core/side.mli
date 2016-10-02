open Data.Shared
type t = side

val opposite : t -> t
val turn     : hand -> t -> t
