module type T = sig
    type t

    val scroll_up   : int -> t -> t
    val scroll_down : int -> t -> t
  end
