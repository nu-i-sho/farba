type t = 
  { _r : float; (* -- radius of inside circle *)
    _R : float  (* -- radius of outside circle *)
  }

let make t =
  (* t is length of side of regular hexagon *)
  let t = float t in
  { _r = 0.86602540378 *. t;
    _R = t
  }

module Coord = struct
    let round x =
      let fractional, integral = modf x in
      (int_of_float integral) 
      + (if fractional > 0.5 then 
	   1 else 
	   0)

    let of_index (x, y) hexagon =
      let _r, _R = hexagon._r, hexagon._R in
      let y = y * 2 + lnot(x mod 2) in
      (round (_R +. (float x) *. (_R +. _r /. 2.0))), 
      (round (((float y) +. 1.0) *. _r))
	       
end
