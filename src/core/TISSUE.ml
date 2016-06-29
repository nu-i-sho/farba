module type T = sig
    type t

    val get : (int * int) -> t -> (Nucleus.t option)
    val set : (int * int) -> (Nucleus.t option) -> t -> t
  end
