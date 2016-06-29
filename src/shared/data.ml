module Pigment = struct
    type t = | None
             | Blue
             | Gray
  end

module Side = struct
    type t = | Up
             | LeftUp
             | RightUp
             | Down
             | LeftDown
             | RightDown
  end

module Relation = struct
    type t = | Direct
             | Inverse
  end

module Nucleus = struct
    (* Nucleus without pigment is Cancer *)
    type t = { pigment : Pigment.t;
                  gaze : Side.t
	     }
  end
