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

module Cell = struct
    type t = { cytoplasm : Pigment.t;
                 nucleus : Nucleus.t
	     }
  end

module AnatomyItem = struct
    type t = | Cytoplasm of Pigment.t
             | Active of Cell.t
             | Static of Cell.t
             | Out of Nucleus.t
             | Clot of Side.t
  end
