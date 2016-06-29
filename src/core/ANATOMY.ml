module type T = sig
    type t

    val height    : t -> int
    val width     : t -> int
    val is_out    : (int * int) -> t -> bool
    val cell      : (int * int) -> t -> (Nucleus.t option)
    val cytoplasm : (int * int) -> t -> Pigment.t
    val set       : (int * int) -> (Nucleus.t option) -> t -> t
    val clot      : t -> t
    val out       : t -> t
    val clotted   : t -> bool
    val outed     : t -> bool

  end
