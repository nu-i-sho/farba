type t

val make : Program.t -> TissueCell.t -> t
val next : t -> t option
val run  : t -> unit
