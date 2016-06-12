type t = {     hexagon : Hexagon.t;
                radius : float;
	    eye_radius : float
	 }

let make h =
  let r = Hexagon.internal_radius_f h in
  {    hexagon = h; 
        radius = r *. 0.8;
    eye_radius = r *. 0.1
  }

let radius o = 
  Int.round o.radius
 
let eye_radius o = 
  Int.round o.eye_radius

let eyes_coords _ _ _ = 
  (0, 0)

let cancer_eyes_coords _ _ _ = 
  ((0, 0), (0, 0))
