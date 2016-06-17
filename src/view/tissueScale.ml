module Make (Seed : TISSUE_SCALE.SEED.T) = struct

    module Hexagon = struct

	let external_radius = 
	  Seed.hexagon_side

	let side =
	  Int.round external_radius

	let internal_radius = 
	  external_radius *. Const.sqrt_3_div_2

	let angles =
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

    let calc_coord f g radius angle sector =  
	((f (angle +. (Const.pi_div_3 *. (float sector)))) *.
	  (g radius)) 
	|> Int.round

    let calc_x = calc_coord cos (~+.)
    let calc_y = calc_coord sin (~-.)

    let circle_point sector radius angle = 
      (calc_x radius angle sector),
      (calc_y radius angle sector)
      
    module Nucleus = struct
	let radiusf = Hexagon.internal_radius *. 0.9
	let radius = Int.round radiusf
	let nucleolus_radius = radiusf *. 0.9
	let eyes_radius = 
	  Int.round (Const.pi_div_30 *. nucleolus_radius) 

	let eyes_coords side =
	  let i = Side.index_of side in
	  let eye_point = circle_point i nucleolus_radius in
	  eye_point Const.pi_div_10,
	  eye_point Const.pi_div_30_mul_7
      end

    module Cancer = struct
	let r0 = Nucleus.radiusf *. 0.95  
	let r1 = Nucleus.radiusf *. 0.9
	let r2 = Nucleus.radiusf *. 0.85
	let eyes_coords side = 
	  let i = Side.index_of side in
	  let point = circle_point i in
	  let p00 = point r0 Const.pi_div_15 in
	  let p01 = point r0 Const.pi_div_15_mul_4 in
	  let p10 = point r1 Const.pi_div_15_mul_2 in
	  let p11 = point r1 Const.pi_div_5 in
	  let p20 = point r2 Const.pi_div_15 in
	  let p21 = point r2 Const.pi_div_15_mul_4 in 
	  [ p00, p10;
	    p20, p10;
	    p01, p11;
	    p21, p11	  
	  ]
      end

    module Clot = struct
	let eyes_coords side = []	  
      end
		       
  end
