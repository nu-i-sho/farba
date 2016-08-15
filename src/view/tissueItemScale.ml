type t = float

let make hexagon_side =
  hexagon_side

let round i =
  let fractional, integral = modf i in
  (int_of_float integral) 
  + (if fractional > 0.5 then 
       1 else 
       0)

let sector =
  function | Data.Side.RightUp   -> 0
           | Data.Side.Up        -> 1
           | Data.Side.LeftUp    -> 2
           | Data.Side.LeftDown  -> 3
           | Data.Side.Down      -> 4
           | Data.Side.RightDown -> 5
  
module Hexagon = struct
    let external_radius o = o
    let side o = round (external_radius o)
    let internal_radius o =
      (external_radius o) *. Const.sqrt_3_div_2

    let angles o =
      let e  = round (external_radius o) in
      let i  = round (internal_radius o) in
      let e' = round ((external_radius o) *. 0.5) in

      [| +e', -i;
         +e ,  0;
         +e', +i;
         -e', +i;
         -e ,  0;
         -e', -i; 
      |]
  end

module Cytoplasm = struct
    let eyes_radius o = 0
    let eyes_coords o = (0, 0), (0, 0)
  end

let calc_coord f g radius angle sector =  
  ((f (angle +. (Const.pi_div_3 *. (float sector)))) *.
     (g radius)) 
  |> round

let calc_x = calc_coord cos (~+.)
let calc_y = calc_coord sin (~-.)

let circle_point sector radius angle = 
  (calc_x radius angle sector),
  (calc_y radius angle sector)
      
module Nucleus = struct
    let radiusf o = (Hexagon.internal_radius o) *. 0.9
    let radius o = round (radiusf o)
    let eyes_line_radius o = (radiusf o) *. 0.8
    let eyes_radius o = 
      round (Const.pi_div_30 *. (eyes_line_radius o)) 

    let eyes_coords side o =
      let eye_point =
        circle_point (sector side) (eyes_line_radius o) in
      eye_point Const.pi_div_10,
      eye_point Const.pi_div_30_mul_7
  end

module Cancer = struct
    let eyes_coords side o =

      let r0 = (Nucleus.radiusf o) *. 0.85  
      and r1 = (Nucleus.radiusf o) *. 0.8
      and r2 = (Nucleus.radiusf o) *. 0.75 
      and point = circle_point (sector side) in
      
      let p00 = point r0 Const.pi_div_15
      and p01 = point r0 Const.pi_div_15_mul_4
      and p10 = point r1 Const.pi_div_15_mul_2
      and p11 = point r1 Const.pi_div_5
      and p20 = point r2 Const.pi_div_15
      and p21 = point r2 Const.pi_div_15_mul_4 in 

      [ p00, p10;
	p20, p10;
	p01, p11;
	p21, p11	  
      ]
  end

module Clot = struct
    let eyes_coords side o = []	  
  end
