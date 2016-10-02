open Shared

type cytoplasm = pigment
type clot = side

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
             | Clot of clot
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
                 | DoClot of cell * clot
                 | MoveOut of nucleus
                 | DummyAct of dummy_action
      end
                             
    type init   = (InitValue.t, (int * int)) indexed
    type update = (UpdateEvent.t, (int * int)) indexed
  end

module WeaverStage = struct
    type pass_status =
      | Dummy
      | Success
                  
    type move_status =
      | Dummy
      | Success
      | ToClot
      | Out
      
    type t = | Created
             | Turned
             | Passed of pass_status
             | Moved of move_status 
             | Replicated of move_status
  end
