module Make (sig val hexagon_side : int end) : sig
   
    module Hexagon : sig
	val side : int
	val internal_radius : float
	val external_radius : float
	val agles : Point.t array
      end

    module Cytoplazm : sig
	val eyes_radius : int
	val eyes_coords : DoublePoint.t
      end

    module Nucleus : sig
	val radius : int
	val eyes_radius : int
	val eyes_coords : DoublePoint.t
      end

    module Cancer : sig
	val eyes_coords : DoubleLine.t
      end

    module Clot : sig
	val eyes_coords : DoubleLine.t
      end
		       
  end
