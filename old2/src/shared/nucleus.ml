module Hels = struct
    type t = { pigment : Pigment.t;
	          eyes : Pigment.t; 
		  gaze : Side.t
	     }
  end

module Cancer = struct
    type t = { gaze : Side.t }
  end

type t = | Hels of Hels.t
         | Cancer of Cancer.t
