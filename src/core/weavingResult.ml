module OfMove = struct
    type 'a t = | Dummy of 'a
                | Success of 'a
	        | Clot of 'a
	        | Outed of 'a
  end

module OfPass = struct
    type 'a t = | Dummy of 'a
                | Success of 'a
  end
