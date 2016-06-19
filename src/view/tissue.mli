module Make (Frame : CANVAS.T)
	    (Donor : TISSUE.T) : sig

    include TISSUE.T
    val make : donor  : Donor.t
            -> width  : int
            -> height : int
            -> t
  end
