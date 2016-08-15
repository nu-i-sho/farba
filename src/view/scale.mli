type t

val make : int -> int -> int -> int -> t

module Hexagon : sig
    val side            : t -> int
    val internal_radius : t -> float
    val external_radius : t -> float
    val angles          : t -> (int * int) array
  end

module Tissue : sig
    val dx : t -> int
    val dy : t -> int
  end
     
module Cytoplasm : sig
    val eyes_radius : t -> int
    val eyes_coords : t -> ((int * int) * (int * int))
  end

module Nucleus : sig
    val radius      : t -> int
    val eyes_radius : t -> int
    val eyes_coords : Data.Side.t -> t
                   -> ((int * int) * (int * int))
  end

module Cancer : sig
    val eyes_coords : Data.Side.t -> t
                   -> ((int * int) * (int * int)) list
  end

module Clot : sig
    val eyes_coords : Data.Side.t -> t
                   -> ((int * int) * (int * int)) list
  end
