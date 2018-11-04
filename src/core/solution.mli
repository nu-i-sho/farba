type t

val make   : Tape.t -> Tissue.Coord.t -> t
val cursor : t -> Tissue.Coord.t
val tape   : t -> Tape.t
