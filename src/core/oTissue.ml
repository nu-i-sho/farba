type t = Tissue.t

let cytoplasm     = Tissue.cytoplasm
let cytoplasm_opt = Tissue.cytoplasm_opt
let nucleus       = Tissue.nucleus
let nucleus_opt   = Tissue.nucleus_opt
let cursor        = Tissue.cursor
let clot          = Tissue.clot
       
module Coord = Tissue.Coord

module Constructor = struct
  module Event = struct
    type t =
      | Cytoplasm_was_added of Pigment.t * Coord.t
      | Nucleus_was_added of Nucleus.t * Coord.t
      | Cursor_was_set of Coord.t
      | Clot_was_set of Coord.t
    end

  module Base = Tissue.Constructor
  module Subj = Subject.Make (Event)
  module OBSERVER = Subj.OBSERVER
  module Command = Base.Command

  type event = Event.t
  type 'a subscription = 'a Subj.subscription
  type 'a observer     = 'a Subj.observer
             
  type t =
    { base : Base.t;
      subj : Subj.t
    }

  let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
    let subscription, subj = Subj.subscribe (module Obs) obs_init o.subj in
    subscription, { o with subj }

  let unsubscribe subscription o =
    let obs, subj = Subj.unsubscribe subscription o.subj in
    obs, { o with subj }

  let empty =
  { base = Base.empty;
    subj = Subj.empty
  }

  let perform command o =
    let base = o.base |> Base.perform command 
    and i    = o.base |> Base.product
                      |> Tissue.cursor in
    let event =
      match command with
      | Command.Move side       -> None
      | Command.Add_cytoplasm x -> Some (Event.Cytoplasm_was_added (x, i))
      | Command.Add_nucleus   x -> Some (Event.Nucleus_was_added (x, i))
      | Command.Set_cursor      -> Some (Event.Cursor_was_set i)
      | Command.Set_clot        -> Some (Event.Clot_was_set i) in
    let subj =
      match event with
      | Some x -> o.subj |> Subj.send x
      | None   -> o.subj in
    { base;
      subj
    }

  let product o =
    Base.product o.base
    
  end

module Destructor = struct
  module Event = struct
    type t =
      | Cytoplasm_was_removed of Pigment.t * Coord.t
      | Nucleus_was_removed of Nucleus.t * Coord.t
      | Cursor_was_removed of Coord.t
      | Clot_was_removed of Coord.t
    end
        
  module Base = Tissue.Destructor
  module Subj = Subject.Make (Event)
  module OBSERVER = Subj.OBSERVER

  type event = Event.t
  type 'a subscription = 'a Subj.subscription
  type 'a observer     = 'a Subj.observer

  type cell =
    { cytoplasm : Pigment.t option;
        nucleus : Nucleus.t option;
      is_cursor : bool;
        is_clot : bool
    }
                       
  type t =
    {  base : Base.t;
       subj : Subj.t;
      coord : Coord.t;
        acc : cell;
    }

  let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
    let subscription, subj = Subj.subscribe (module Obs) obs_init o.subj in
    subscription, { o with subj }

  let unsubscribe subscription o =
    let obs, subj = Subj.unsubscribe subscription o.subj in
    obs, { o with subj }

  let empty_cell =
     { cytoplasm = None;
         nucleus = None;
       is_cursor = false;
         is_clot = false
     }
    
  let make tissue =
    { coord = Coord.zero;
       base = Base.make tissue;
       subj = Subj.empty;
        acc = empty_cell
    }

  let next o =
    let i = o.coord in
    let produce o =
      let send_if condition event o =
        if condition then
          let event = Lazy.force event in
          let subj  = Subj.send event o.subj in
          { o with subj } else
            o in
      
      { ( o |> send_if o.acc.is_clot
                 ( lazy( Event.Clot_was_removed i
                 ))
            |> send_if o.acc.is_cursor
                 ( lazy( Event.Cursor_was_removed i
                 ))
            |> send_if (Option.is_some o.acc.nucleus)
                 ( lazy( let n = Option.get o.acc.nucleus in
                         Event.Nucleus_was_removed (n, i)
                 ))
            |> send_if (Option.is_some o.acc.cytoplasm)
                 ( lazy( let c = Option.get o.acc.cytoplasm in
                         Event.Cytoplasm_was_removed (c, i)
                 ))
        ) with acc = empty_cell
      } in
      
    let command, base = Base.next o.base in
    let o = { o with base } in
    let o = match command with
            | None                                       -> produce o      
            | Some (Constructor.Command.Add_cytoplasm c) ->
               let acc = { o.acc with cytoplasm = Some c }
                      in { o with acc }
            | Some (Constructor.Command.Add_nucleus n)   ->
               let acc = { o.acc with nucleus = Some n }
                      in { o with acc }
            | Some (Constructor.Command.Set_cursor)      ->
               let acc = { o.acc with is_cursor = true }
                      in { o with acc }
            | Some (Constructor.Command.Set_clot)        ->
               let acc = { o.acc with is_clot = true }
                      in { o with acc }

            | Some (Constructor.Command.Move side)       ->
                         { (produce o) with
                           coord = Coord.move side i
                         } in
    command,
    o
    
  end
                   
module Cursor = struct
  module Event = struct
    type 'a change =
      { before : 'a;
         after : 'a
      }
    
    type tissue_cell =
      {     coord : Tissue.Coord.t; 
          nucleus : Nucleus.t option;
        cytoplasm : Pigment.t option;
          clotted : bool;
        cursor_in : bool
      }

    type 'result move =
      { direction :  Side.t;
           change : (tissue_cell * tissue_cell) change;
           result : 'result
      }

    type turned_msg =
      { direction : Hand.t;
           change : tissue_cell change;
      }

    type moved_mind_msg =
      [`Success | `Fail] move

    type moved_body_msg =
      [`Success | `Fail | `Clotted | `Rev_gaze] move

    type replicated_msg = 
      {      gene : Gene.t;
        direction : Side.t;
           change : (tissue_cell * tissue_cell) change;
           result : [`Success | `Fail | `Clotted | `Self_clotted]
      }

    type t = 
      | Turned of turned_msg
      | Moved_mind of moved_mind_msg
      | Moved_body of moved_body_msg
      | Replicated of replicated_msg
    end

  module Base = Tissue.Cursor
  module Subj = Subject.Make (Event)
  module OBSERVER = Subj.OBSERVER
  module Command = Base.Command
                  
  type event = Event.t
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
  let is_out_of_tissue o = o.base |> Base.is_out_of_tissue
  let is_clotted       o = o.base |> Base.is_clotted

  exception Clotted       = Base.Clotted
  exception Out_of_tissue = Base.Out_of_tissue 

  let perform command o =
    let open Event in
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
    
  end
