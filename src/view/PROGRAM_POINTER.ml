module type T = sig
    type t
    val make : int -> t
    val get  : int -> t -> Point.t
  end
