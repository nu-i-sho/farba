open Data.Tissue
open Utils
   
module type T = sig
    type t

    val height     : t -> int
    val width      : t -> int
    val init_items : t -> Item.InitValue.t Matrix.t
    val items      : t -> Item.t Matrix.t
    val flora      : t -> cytoplasm IntPointMap.t
    val fauna      : t -> nucleus IntPointMap.t
    val weaver     : t -> int * int
  end
