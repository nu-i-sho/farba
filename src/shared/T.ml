module type TISSUE_OBSERVER = sig
    type t

    val init  : int -> int -> t -> t
    val set   : (int * int) -> Data.TissueItem.t -> t -> t
    val reset : (int * int)
             -> Data.TissueItem.t
             -> Data.TissueItem.t
             -> t
             -> t
  end

