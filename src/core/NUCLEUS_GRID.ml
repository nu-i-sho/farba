module type T = sig

    type t

    val set        : (int * int) -> NucleusGridItem.t -> t -> t
    val get        : (int * int) -> t -> NucleusGridItem.t
    val activate   : (int * int) -> t -> t
    val deactivate : (int * int) -> t -> t
    val clot       : (int * int) -> Side.t -> t -> t
    val out        : (int * int) -> Nucleus.t -> t -> t

  end
