type tissue_build := Tissue.Constructor.Command.t list

type t =
  { tissue_build : tissue_build;
            tape : Tape.t
  }

exception Is_corrupted of string
exception Not_found of string
exception Permission_denied of string

val make    : tissue_build -> Tape.t -> t
val restore : int -> string -> t
val save    : int -> string -> t -> unit
val exists  : int -> string -> bool
