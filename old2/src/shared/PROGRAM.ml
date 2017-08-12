module type T = sig
    type t

    val get       : int -> t -> Command.t
    val length    : t -> int
    val of_string : string -> t
    val to_string : t -> string

  end
