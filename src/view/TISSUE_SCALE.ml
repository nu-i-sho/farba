module type T = sig

    module Hexagon : sig
	val side : int
	val internal_radius : float
	val external_radius : float
	val agles : Point.t array
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
	val eyes_coords : Side.t -> DoubleLine.t
      end

    module Clot : sig
	val eyes_coords : Side.t -> DoubleLine.t
      end
		       
  end
