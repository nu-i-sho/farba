open Data.Program
   
module type T = sig
    type t

    val height      : t -> int
    val width       : t -> int
    val init_line   : Line.init -> t -> t
    val init_item   : Item.init -> t -> t
    val update_line : Line.update -> t -> t
    val update_item : Item.update -> t -> t
  end
