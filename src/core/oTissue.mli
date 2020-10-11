type t = Tissue.t

module Coord : module type of Tissue.Coord
       
module Constructor : sig
  module Event : sig
    type t = private | Cytoplasm_was_added of Pigment.t * Coord.t
                     | Nucleus_was_added of Nucleus.t * Coord.t
                     | Cursor_was_set of Coord.t
                     | Clot_was_set of Coord.t
    end
     
  include module type of Tissue.Constructor
             with module Command = Tissue.Constructor.Command
                       
  include OBSERV.ABLE.S
     with type event = Event.t
      and type t := t       
  end

module Destructor : sig
  module Event : sig
    type t = private | Cytoplasm_was_removed of Pigment.t * Coord.t
                     | Nucleus_was_removed of Nucleus.t * Coord.t
                     | Cursor_was_removed of Coord.t
                     | Clot_was_removed of Coord.t
    end

  include module type of Tissue.Destructor
  include OBSERV.ABLE.S   
     with type event = Event.t
      and type t := t   
  end
     
module Cursor : sig
  
  module Event : sig
    type 'a change =
      private { before : 'a;
                 after : 'a
              }
    
    type tissue_cell =
      private {     coord : Coord.t; 
                  nucleus : Nucleus.t option;
                cytoplasm : Pigment.t option;
                  clotted : bool;
                cursor_in : bool
              }

    type 'result move =
      private { direction :  Side.t;
                   change : (tissue_cell * tissue_cell) change;
                   result : 'result
              }

    type turned_msg =
      private { direction : Hand.t;
                   change : tissue_cell change;
              }

    type moved_mind_msg =
      private [`Success | `Fail] move

    type moved_body_msg =
      private [`Success | `Fail | `Clotted | `Rev_gaze] move

    type replicated_msg = 
      private {      gene : Gene.t;
                direction : Side.t;
                   change : (tissue_cell * tissue_cell) change;
                   result : [`Success | `Fail | `Clotted | `Self_clotted]
              }

    type t = 
      private | Turned of turned_msg
              | Moved_mind of moved_mind_msg
              | Moved_body of moved_body_msg
              | Replicated of replicated_msg
    end

  include module type of Tissue.Cursor
             with module Command = Tissue.Cursor.Command
                       
  include OBSERV.ABLE.S
     with type event = Event.t
      and type t := t

  end
