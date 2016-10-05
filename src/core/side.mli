open Data.Shared
type t = side

val of_char  : char -> t
val opposite : t -> t
val turn     : hand -> t -> t
