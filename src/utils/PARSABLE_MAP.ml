module type T = sig
    include MAP_EXT.T
    val of_string : (string -> 'a) -> string -> 'a t
  end
