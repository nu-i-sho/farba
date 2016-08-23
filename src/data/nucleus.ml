type t = { pigment : Pigment.t;
              gaze : Side.t
	 }
       
let is_cancer o =
  o.pigment = Pigment.White
