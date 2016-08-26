type t

val push : ProgramLine.t -> t -> t
val top  : t -> ProgramLine.t
val pop  : t -> t
