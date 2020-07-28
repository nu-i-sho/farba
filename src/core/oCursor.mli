type event = 
  private | Turned of
              { direction : Hand.t;
                   change : tissue_cell change;
              }
          | Moved_mind of [`Success | `Fail] move
          | Moved_body of [`Success | `Fail | `Clotted | `Rev_gaze] move
          | Replicated of
              {      gene : Gene.t;
                direction : Side.t;
                   change : (tissue_cell * tissue_cell) change;
                   result : [`Success | `Fail | `Clotted | `Self_clotted]
              }

 and 'a change =
  private { before : 'a;
             after : 'a
          }
    
 and tissue_cell =
   private {     coord : Tissue.Coord.t; 
               nucleus : Nucleus.t option;
             cytoplasm : Pigment.t option;
               clotted : bool;
             cursor_in : bool
           }

 and 'result move =
   private { direction :  Side.t;
                change : (tissue_cell * tissue_cell) change;
                result : 'result
           }
     
include CURSOR.S
include OBSERV.ABLE.S
   with type event := event
    and type t := t
