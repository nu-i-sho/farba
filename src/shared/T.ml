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

module type CALL_STACK_OBSERVER = sig
    type t

    val reset : Data.RuntimePoint.t -> Data.RuntimePoint.t -> t -> t
    val init  : Data.Command.t array
             -> Data.RuntimePoint.t
             -> t
             -> t
  end
