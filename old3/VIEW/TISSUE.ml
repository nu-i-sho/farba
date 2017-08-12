open Data.Tissue

module type T = sig
    type t

    val init        : int -> int -> t -> t
    val init_item   : Item.Init.t -> t -> t
    val update_item : Item.Update.t -> t -> t
  end
