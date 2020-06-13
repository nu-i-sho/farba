type e = (Command.t, Dots.t, Dots.t) Statement.t
type t = e list

val empty  : t
val load   : char Seq.t -> t * char Seq.t
val unload : t -> char Seq.t
