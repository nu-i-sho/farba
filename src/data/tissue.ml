open Shared

type cytoplasm = pigment
               
type nucleus =
  { pigment : pigment;
       gaze : side
  }

type cell =
  { cytoplasm : cytoplasm;
      nucleus : nucleus
  }

type item =
  | Cytoplasm of cytoplasm
  | Active of cell
  | Static of cell
  | Clot of side
  | Outed of nucleus
  | Out

module WeaverStage = struct
    module StatusOf = struct
        module Pass = struct
            type t = | Dummy
                     | Success
          end
                    
        module Move = struct
            type t = | Dummy
                     | Success
	             | ToClot
	             | Out
          end          
      end
  
    type t = | Created
             | Turned
             | Passed of StatusOf.Pass.t
             | Moved of StatusOf.Move.t 
             | Replicated of StatusOf.Move.t
  end
