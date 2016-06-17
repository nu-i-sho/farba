module type T = sig
    type t
    val get : int -> t -> Point.t
  end
