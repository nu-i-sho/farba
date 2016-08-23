open Data
module type T = sig
    type t

    val init        : int -> int -> t -> t
    val init_item   : (int * int) -> TissueItemInit.t -> t -> t
    val update_item : (int * int) -> TissueItemUpdate.t -> t -> t
  end
