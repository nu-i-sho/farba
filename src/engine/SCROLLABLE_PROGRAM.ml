module type T = sig
    include PROGRAM.T
    val move_up   : t -> t
    val move_down : t -> t
    val focus     : t -> t
  end
