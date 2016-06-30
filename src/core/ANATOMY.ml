module type T = sig
    type t

    val height    : t -> int
    val width     : t -> int
    val is_out    : (int * int) -> t -> bool
    val nucleus   : (int * int) -> t -> (Nucleus.t option)
    val cytoplasm : (int * int) -> t -> Pigment.t
    val set       : (int * int) -> (Nucleus.t option) -> t -> t
    val set_clot  : (int * int) -> Side.t -> t -> t
    val set_out   : (int * int) -> Nucleus.t -> t -> t
    val clotted   : t -> bool
    val outed     : t -> bool

  end
