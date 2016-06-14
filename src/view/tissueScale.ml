module Make (Seed : TISSUE_SCALE.SEED.T) = struct

    module Hexagon = struct

	let external_radius = 
	  Seed.hexagon_side

	let side =
	  Int.round external_radius

	let internal_radius = 
	  external_radius *. Const.sqrt_3_div_2

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

    module Cytoplasm = struct
	let eyes_radius = 0
	let eyes_coords = (0, 0), (0, 0)
      end

    module Nucleus = struct
	let radius = 0
	let eyes_radius = 0
	let eyes_coords _ = (0, 0), (0, 0)
      end

    module Cancer = struct
	let eyes_coords _ = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end

    module Clot = struct
	let eyes_coords _ = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end
		       
  end
