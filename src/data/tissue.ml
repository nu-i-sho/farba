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

module Item = struct
    type t = | Cytoplasm of cytoplasm
             | Active of cell
             | Static of cell
             | Clot of side
             | Outed of nucleus
             | Out

    module InitValue = struct
        type t = | Cytoplasm of cytoplasm
                 | Active of cell
                 | Static of cell
                 | Out
      end

    module UpdateEvent = struct
        type dummy_action =
          | Replicate
          | Pass
          | Move

        type t = | Inject of cytoplasm * cell
                 | Extract of cell * cytoplasm
                 | Turn of cell * cell
                 | VirusOut of cell * cell
                 | Infect of cell * cell
                 | DoClot of cell * side
                 | MoveOut of nucleus
                 | DummyAct of dummy_action
      end
                             
    type init   = (InitValue.t, (int * int)) indexed
    type update = (UpdateEvent.t, (int * int)) indexed
  end

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
