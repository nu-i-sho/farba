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
    let radiusf = Hexagon.internal_radius *. 0.9
	let radius = Int.round radiusf
	let nucleolus_radius = radiusf *. 0.9
	let eyes_radius = 
	  Int.round (Const.pi *. nucleolus_radius /. 30.0) 

	let angles_inc = [| Const.pi /. 10.0; 
	                    Const.pi *. 7.0 /. 30.0 
	                 |]

	let eyes_coords side = 
	  let i = float (Side.index_of side) in
	  let calc_angles f g =
	    angles_inc |> Array.copy
	               |> Array.map ((+.) (Const.pi /. 3.0 *. i)) 
	               |> Array.map f
	               |> Array.map (( *.) (g nucleolus_radius))
	               |> Array.map Int.round
	  in

	  let x_angles = calc_angles cos (~+.) in
	  let y_angles = calc_angles sin (~-.) in  
	  (x_angles.(0), y_angles.(0)),
	  (x_angles.(1), y_angles.(1))
      end

    module Cancer = struct
	let eyes_coords _ = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end

    module Clot = struct
	let eyes_coords _ = ((0, 0), (0, 0)), ((0, 0), (0, 0))
      end
		       
  end
