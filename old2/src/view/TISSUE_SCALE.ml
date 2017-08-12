module type T = sig

    module Hexagon : sig
	val side : int
	val internal_radius : float
	val external_radius : float
	val angles : Point.t array
      end

    module Cytoplasm : sig
	val eyes_radius : int
	val eyes_coords : DoublePoint.t
      end

    module Nucleus : sig
	val radius : int
	val eyes_radius : int
	val eyes_coords : Side.t -> DoublePoint.t
      end

    module Cancer : sig
	val eyes_coords : Side.t -> Line.t list
      end

    module Clot : sig
	val eyes_coords : Side.t -> Line.t list
      end
		       
  end

module SEED = struct
    module type T = sig 
	val hexagon_side : float 
      end
  end

module MAKE = struct
    module type T = 
      functor (Seed : SEED.T) -> T
  end
