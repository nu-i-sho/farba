type dots =
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
  | Call of dots
  | Declare of dots
  | Nope
  | End
  
type level_path =
  {    branch : dots;
    branchlet : dots;
         leaf : dots
  }
  
type 'a doubleable =
  | Double of 'a * 'a
  | Single of 'a

module Crumb = struct
  
    type t = dots doubleable  
    type active_stage =
      | Find
      | Run
                        
    type stage =
      | Active of active_stage
      | Wait
  end

type 'a staged_crumb =
  { value : Crumb.t;
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
