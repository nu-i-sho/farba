type t

val make : int -> int -> int -> int -> t

module Hexagon : sig
    val side            : t -> float
    val internal_radius : t -> float
    val external_radius : t -> float
    val angles          : t -> (float * float) array
  end

module Tissue : sig
    val dx : t -> int
    val dy : t -> int
  end
     
module Cytoplasm : sig
    val eyes_radius : t -> float
    val eyes_coords : t -> ((float * float) * (float * float))
  end

module Nucleus : sig
    val radius      : t -> float
    val eyes_radius : t -> float
    val eyes_coords : Data.Side.t -> t
                   -> ((float * float) * (float * float))
  end

module Cancer : sig
    val eyes_coords : Data.Side.t -> t
                   -> ((float * float) * (float * float)) list
  end

module Clot : sig
    val eyes_coords : Data.Side.t -> t
                   -> ((float * float) * (float * float)) list
  end
