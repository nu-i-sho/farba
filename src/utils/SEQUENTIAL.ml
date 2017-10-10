module type T = sig
    type t
    val succ : t -> t
    val pred : t -> t
  end
