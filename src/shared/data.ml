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

module Statistics = struct
    module OfActs = struct
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
                  
    module OfTissue = struct
        type t = { healthy_cells_capacity : int;
                            healthy_cells : int;
                             cancer_cells : int;
                                is_cloted : bool;
                                 is_outed : bool;
                 }
      end

    type t = { tissue : OfTissue.t; 
                 acts : OfActs.t
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

module Hand = struct
    type t = | Left
             | Right
  end

module Command = struct
    type t = | Pass
             | Move
             | Turn of Hand.t
             | Replicate of Relation.t
             | Call of DotsOfDice.t
             | Declare of DotsOfDice.t
             | Nope
             | End
  end

module CallStackPoint = struct
    module Value = struct
        type t = | Double of DotsOfDice.t * DotsOfDice.t
                 | Single of DotsOfDice.t
      end

    type t = { value : Value.t;
               index : int
             }
  end

module RuntimeMode = struct
    type t = | Run
             | GoTo
             | Return
  end
