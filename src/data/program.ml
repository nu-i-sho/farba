open Shared
open Utils
   
type crumb = Crumb.stage staged_crumb

module Item = struct
    type t = crumb option crumbed_command
    type init   = (t, int * int) indexed
    type update = (t change, int * int) indexed
  end

type snake_line =
  | FromLeftToRight of Item.t Vector.t
  | Right of Item.t
  | FromRightToLeft of Item.t Vector.t
  | Left of Item.t
                
module Line = struct
    type kind =
      | Crumbed
      | Stacked
      | Active
      | Simple
     
    type attribute =
      {  active : bool;
        crumbed : bool;
      }

    type init   = (kind, int) indexed
    type update = (kind change, int) indexed
                    
    type t = (snake_line, int, attribute) attributable 
  end
                
module Active = struct
    type crumb = Crumb.active_stage staged_crumb
    type item  = crumb crumbed_command
    type line  = (snake_line, int) indexed
  end

module Stackable = struct
    module Line = struct
        type attribute =
          { stacked : bool;
             active : bool;
            crumbed : bool
          }

        type t = (snake_line, int, attribute) attributable
      end
                    
    module ActiveLine = struct
        type attribute = { stacked : bool }                 
        type t = (snake_line, int, attribute) attributable
      end
  end
