module Make (O : sig val hexagon_side : int end) = struct
   
    module Hexagon = struct

	let side = 
	  O.hexagon_side

	let external_radius = 
	  float side

	let internal_radius = 
	  external_radius *. 0.8

	let agles =
	  let e  = Int.round external_radius in
	  let i  = Int.round internal_radius in
	  let e' = Int.round (external_radius *. 0.5) in

	  [| +e', -i;
             +e ,  0;
             +e', +i;
             -e', +i;
             -e ,  0;
             -e', -i; 
	  |]
      end

    module Cytoplazm = struct
	let eyes_radius = 0
	let eyes_coords = (0, 0), (0, 0)
      end

    module Nucleus = struct
	let radius = 0
	let eyes_radius = 0
	let eyes_coords = (0, 0), (0, 0)
      end

    module Cancer = struct
	let eyes_coords = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end

    module Clot = struct
	let eyes_coords = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end
		       
  end
