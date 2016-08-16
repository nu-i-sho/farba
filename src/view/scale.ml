type t = {  hexagon_external_r : float;
            hexagon_internal_r : float;
                hexagon_angles : (float * float) array;
                     tissue_dx : int;
                     tissue_dy : int;
                     nucleus_r : float;
           nucleus_eyes_line_r : float;
                nucleus_eyes_r : float
         }
       
let make canvas_height canvas_width
         tissue_height tissue_width =

  let canvas_height = float canvas_height
  and canvas_width  = float canvas_width
                    
                            (* + 2 for outed nucleuses *)
  and tissue_height = float (tissue_height + 2)
  and tissue_width  = float (tissue_width  + 2) in
  
  let max_horizontal_side =
    canvas_width  /. (tissue_width  *. 1.5 +. 0.5)
  and max_vertical_side =
    canvas_height /. (tissue_height *. 2.0 +. 1.0)
                  /. Const.sqrt_3_div_2 in
  
  let hexagon_external_r = min max_horizontal_side
                               max_vertical_side in
  let hexagon_internal_r = hexagon_external_r *.
                             Const.sqrt_3_div_2 in
  let hexagon_angles =
    let e  = hexagon_external_r
    and i  = hexagon_internal_r
    and e' = hexagon_external_r *. 0.5 in

      [| +.e', -.i;
         +.e , 0.0;
         +.e', +.i;
         -.e', +.i;
         -.e , 0.0;
         -.e', -.i
      |]
  
  and tissue_height' = 
    hexagon_internal_r *. (tissue_height *. 2.0 +. 1.0)
  and tissue_width'  =
    hexagon_external_r *. (tissue_width  *. 1.5 +. 0.5) in
  let tissue_dx =
    ((tissue_width -. tissue_width') /. 2.0)
        |> ceil
        |> int_of_float
  and tissue_dy =
    ((tissue_height -. tissue_height') /. 2.0)
        |> ceil
        |> int_of_float in

  let nucleus_r = hexagon_internal_r *. 0.9 in
  let nucleus_eyes_line_r = nucleus_r *. 0.8 in
  let nucleus_eyes_r =
    Const.pi_div_30 *. nucleus_eyes_line_r in

  {  hexagon_external_r;
     hexagon_internal_r;
         hexagon_angles;
              tissue_dx;
              tissue_dy;
              nucleus_r;
    nucleus_eyes_line_r;
         nucleus_eyes_r
  }
    
module Hexagon = struct
    let external_radius o = o.hexagon_external_r
    let side            o = o.hexagon_external_r
    let internal_radius o = o.hexagon_internal_r
    let angles          o = o.hexagon_angles
  end

module Tissue = struct
    let dx o = o.tissue_dx
    let dy o = o.tissue_dy       
  end
               
module Cytoplasm = struct
    let eyes_radius o = 0.0
    let eyes_coords o = (0.0, 0.0), (0.0, 0.0)
  end

let sector =
  function | Data.Side.RightUp   -> 0.0
           | Data.Side.Up        -> 1.0
           | Data.Side.LeftUp    -> 2.0
           | Data.Side.LeftDown  -> 3.0
           | Data.Side.Down      -> 4.0
           | Data.Side.RightDown -> 5.0

let calc_coord f g radius angle sector =  
  (f (angle +. (Const.pi_div_3 *. sector))) *. (g radius)

let calc_x = calc_coord cos (~+.)
let calc_y = calc_coord sin (~-.)

let circle_point sector radius angle = 
  (calc_x radius angle sector),
  (calc_y radius angle sector)    
                                  
module Nucleus = struct
    let radius      o = o.nucleus_r
    let eyes_radius o = o.nucleus_eyes_r
    let eyes_coords side o =
      let eye_point =
        circle_point (sector side) o.nucleus_eyes_line_r in
      eye_point Const.pi_div_10,
      eye_point Const.pi_div_30_mul_7
  end

module Cancer = struct
    let eyes_coords side o =
      let r0 = o.nucleus_r *. 0.85
      and r1 = o.nucleus_r *. 0.8
      and r2 = o.nucleus_r *. 0.75
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
