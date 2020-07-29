type event = 
  | Turned of
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
  { before : 'a;
     after : 'a
  }
    
 and tissue_cell =
  {     coord : Tissue.Coord.t; 
      nucleus : Nucleus.t option;
    cytoplasm : Pigment.t option;
      clotted : bool;
    cursor_in : bool
  }

 and 'result move =
  { direction :  Side.t;
       change : (tissue_cell * tissue_cell) change;
       result : 'result
  }

module Base = Cursor
module Subj = Subject.Make (struct type t = event end)
module OBSERVER = Subj.OBSERVER
                
type 'a subscription = 'a Subj.subscription
type 'a observer     = 'a Subj.observer
               
type t =
  { base : Base.t;
    subj : Subj.t;
  }

let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
  let subscription, subj = Subj.subscribe (module Obs) obs_init o.subj in
  subscription, { o with subj }
                  
let unsubscribe subscription o =
  let obs, subj = Subj.unsubscribe subscription o.subj in
  obs, { o with subj } 
 
let make tissue =
  { base = Base.make tissue;
    subj = Subj.empty
  }
  
let tissue           o = o.base |> Base.tissue  
let position         o = o.base |> Base.position
let is_out_of_tissue o = o.base |> Base.is_out_of_tissue
let is_clotted       o = o.base |> Base.is_clotted

exception Clotted       = Base.Clotted
exception Out_of_tissue = Base.Out_of_tissue 

let perform command o =
  let cell i tissue =
    {     coord = i; 
        nucleus = Tissue.nucleus_opt i tissue;
      cytoplasm = Tissue.cytoplasm_opt i tissue;
        clotted = i = (Tissue.clot tissue);
      cursor_in = i = (Tissue.cursor tissue)
    } in 
  let cells i direction tissue =
    let j = Tissue.Coord.move direction i in
    cell i tissue,
    cell j tissue in
    
  let base, event =
    let i = Tissue.cursor (tissue o) in
    match command with
    | Command.Turn hand ->
       let before = cell i (tissue o)
       and base   = Base.perform command o.base in
       let after  = cell i (Base.tissue base) in
       base, Turned { direction = hand;
                         change = { before; after }
                    }
             
    | Command.Move nature ->
       let dir = (Tissue.nucleus i (tissue o)).gaze in
       let ((source, _) as before) = cells i dir (tissue o)
       and base = Base.perform command o.base in
       let ((source', target') as after) =
         cells i dir (Base.tissue base) in
       let event_data = { direction = dir;
                             change = { before; after };
                             result = `Success
                        } in
       
       base, ( match nature with
               | Nature.Mind ->
                  Moved_mind {
                      event_data with
                      result = if target'.cursor_in then
                                 `Success else
                                 `Fail
                    }
                    
               | Nature.Body ->
                  Moved_body {
                      event_data with
                      result = if source'.cursor_in then
                                 ( if (Option.get source .nucleus).gaze = 
                                      (Option.get source'.nucleus).gaze then
                                     `Fail else
                                     `Rev_gaze
                                 ) else
                                 ( if target'.clotted then
                                     `Clotted else
                                     `Success
                                 )
                    }
             )
       
    | Command.Replicate gene ->
       let dir    = (Tissue.nucleus i (tissue o)).gaze in
       let before = cells i dir (tissue o)
       and base   = Base.perform command o.base in
       let ((source', target') as after) =
         cells i dir (Base.tissue base) in
       base, Replicated { 
                      gene;
                 direction = dir;
                    change = { before; after };
                    result = if source'.clotted   then
                               `Self_clotted      else
                             if target'.clotted   then
                               `Clotted           else
                             if source'.cursor_in then
                               `Fail              else
                               `Success                  
               } in
  { base;
    subj = Subj.send event o.subj
  }
