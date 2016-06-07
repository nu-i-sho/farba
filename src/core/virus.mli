type t

val make : (Command.t array) -> Cell.t -> t
val next : t -> t
