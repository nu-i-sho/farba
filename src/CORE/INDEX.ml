open Data

module type T = sig
    type t = int * int     
    val move : Side.t -> t -> t
  end
