type t

val make : Program.t -> Cell.t -> t
val next : t -> t option
val run  : t -> unit
