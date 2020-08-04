module Event : sig
  type 'a change =
    private { before : 'a;
               after : 'a
            }
    
  type tissue_cell =
    private {     coord : Tissue.Coord.t; 
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
     
include CURSOR.S
include OBSERV.ABLE.S
   with type event = Event.t
    and type t := t
