type dots_of_dice =
  | OOOOOO
  | OOOOO
  | OOOO
  | OOO
  | OO
  | O

type pigment =
  | White
  | Blue
  | Gray

type hand =
  | Left
  | Right

type side =
  | Up
  | LeftUp
  | RightUp
  | Down
  | LeftDown
  | RightDown

type relation =
  | Direct
  | Inverse
                
type action =
  | Replicate of relation
  | Turn of hand
  | Move
  | Pass

type command =
  | Act of action
  | Call of dots_of_dice
  | Declare of dots_of_dice
  | Nope
  | End

type 'a doubleable =
  | Double of 'a * 'a
  | Single of 'a

module Crumb = struct
  
    type t = dots_of_dice doubleable  
    type active_stage =
      | Find
      | Run
                        
    type stage =
      | Active of active_stage
      | Wait
  end

type 'a staged_crumb =
  { value : crumb;
    stage : 'a
  }

type 'a crumbed_command =
  { value : command;
    crumb : 'a
  }

type ('a, 'b, 'c) attributable =
  { value : 'a;
    index : 'b;
       is : 'c
  }
                      
type ('a, 'b) indexed =
  { value : 'a;
    index : 'b
  }
                      
type 'a change =
  { previous : 'a;
     current : 'a
  }

module ItemEvent = struct
    type 'a init = 'a indexed
    type 'a update = 'a change indexed
  end
              
module Program = struct
    type crumb = Crumb.stage staged_crumb

    module Item = struct
        type t = crumb option crumbed_command
        type init   = (t, (int * int)) ItemEvent.init
        type update = (t, (int * int)) ItemEvent.update
      end

    type snake_line = | FromLeftToRight of Item.t Std.Vector.t
                      | Right of Item.t
                      | FromRightToLeft of Item.t Std.Vector.t
                      | Left of ProgramItem.t
                
    module Line = struct
        type kind = | Crumbed
                    | Stacked
                    | Active
                    | Simple
     
        type attribute = {  active : bool;
                           crumbed : bool;
                         }

        type init   = (kind, int) ItemEvent.init
        type update = (kind, int) ItemEvent.update
                    
        type t = (snake_line, int, attribute) attributable 
      end
                
    module Active = struct
        type crumb = Crumb.active_stage staged_crumb
        type item  = crumb crumbed_command
        type line  = (snake_line, int) indexed
      end

    module Stackable = struct
        module Line = struct
            type attribute = { stacked : bool;
                                active : bool;
                               crumbed : bool
                             }

            type t = (snake_line, int, attribute) attributable
          end
                    
        module ActiveLine = struct
            type attribute = { stacked : bool }                 
            type t = (snake_Line.t, int, attribute) attributable
          end
      end
  end

module Tissue = struct
    type cytoplasm = pigment
               
    type nucleus  = { pigment : pigment;
                         gaze : side
	            }

    type cell = { cytoplasm : cytoplasm;
                    nucleus : nucleus
	        }

    type item = | Cytoplasm of cytoplasm
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

  end
