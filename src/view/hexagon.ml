type t = 
  { internal_radius : float;
    external_radius : float
  }

let make side =
  let side = float side in
  { internal_radius = side *. 0.86602540378;
    external_radius = side
  }

let internal_radius_f o = o.internal_radius
let external_radius_f o = o.external_radius
let internal_radius o = Int.round (internal_radius_f o)
let external_radius o = Int.round (external_radius_f o)
let side = external_radius

let center_coord_f (x, y) o =
  let r  = internal_radius_f o in
  let r' = external_radius_f o in
  let y  = y * 2 + lnot(x mod 2) in
  (r' +. (float x) *. r' *. 1.5), 
  (((float y) +. 1.0) *. r)

let center_coord i o =
  let x, y = center_coord_f i o in
  (Int.round x), 
  (Int.round y)
 
let angles_coords i o =
  let x, y = center_coord_f i o in
  let r  = internal_radius_f o in
  let r' = external_radius_f o in
  
  Int.([| round (x +. r' /. 2.0), round (y -. r);
	  round (x +. r')       , round  y      ;
	  round (x +. r' /. 2.0), round (y +. r);
	  round (x -. r' /. 2.0), round (y +. r);
	  round (x -. r')       , round  y      ;
	  round (x -. r' /. 2.0), round (y -. r); 
      |])
