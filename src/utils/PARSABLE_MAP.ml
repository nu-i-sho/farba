module type T = sig
    include MAP_EXT.T
    val parse : (string -> 'a) -> string -> 'a t
  end
