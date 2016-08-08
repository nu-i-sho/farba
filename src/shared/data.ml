module Pigment = struct
    type t = | White
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
    type t = { pigment : Pigment.t;
                  gaze : Side.t
	     }
  end

module Cell = struct
    type t = { cytoplasm : Pigment.t;
                 nucleus : Nucleus.t
	     }
  end

module TissueItem = struct
    type t = | Cytoplasm of Pigment.t
             | Active of Cell.t
             | Static of Cell.t
             | Clot of Side.t
             | Outed of Nucleus.t
             | Out
  end

module WeaverActsStatistics = struct
    type t = {      dummy_moves : int;
                   dummy_passes : int;
               dummy_replicates : int;
                          turns : int;
                          moves : int;
                         passes : int;
                     replicates : int;
                      effective : int;
                        dummies : int;
                        summary : int
             }
  end

module DotsOfDice = struct
    type t = | OOOOOO
             | OOOOO
             | OOOO
             | OOO
             | OO
             | O
  end
