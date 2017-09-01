module type T = sig
    type die
    type t

    val top_index : t -> int
    val top_dies  : t -> die list
    val top_die   : t -> die
    val dies      : int -> t -> die list
    val die       : int -> t -> die
    val maybe_die : int -> t -> die option
  end
