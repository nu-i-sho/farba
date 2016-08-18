open Data
module type T = sig
    type t

    val init  : int -> int -> t -> t
    val set   : (int * int) -> TissueItem.t -> t -> t
    val reset : (int * int)
             -> TissueItem.t
             -> TissueItem.t
             -> t
             -> t
  end
