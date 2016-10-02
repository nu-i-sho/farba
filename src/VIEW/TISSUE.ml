open Data.Tissue

module type T = sig
    type t

    val init        : int -> int -> t -> t
    val init_item   : Item.init -> t -> t
    val update_item : Item.update -> t -> t
  end
