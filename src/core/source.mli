type e = (Command.t, Dots.t, Dots.t) Statement.t
type t = e list

val of_string : string -> t
val to_string : t -> string
