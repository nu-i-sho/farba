open Data
open Tools
   
module type T = sig
    type t

    val height     : t -> int
    val width      : t -> int
    val init_items : t -> TissueItemInit.t Matrix.t
    val items      : t -> TissueItem.t Matrix.t
    val fauna      : t -> Nucleus.t IntPointMap.t
    val flora      : t -> Pigment.t IntPointMap.t
    val weaver     : t -> (int * int)
  end
