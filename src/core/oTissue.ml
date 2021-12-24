type t = Tissue.t

let cytoplasm  = Tissue.cytoplasm
let cytoplasm' = Tissue.cytoplasm'
let nucleus    = Tissue.nucleus
let nucleus'   = Tissue.nucleus'
let cursor     = Tissue.cursor
let clot       = Tissue.clot
       
module Coord = Tissue.Coord

module Constructor = struct
  module Event = struct
    type t =
      | Cytoplasm_was_added of Pigment.t * Coord.t
      | Nucleus_was_added of Nucleus.t * Coord.t
      | Cursor_was_set of Coord.t
      | Clot_was_set of Coord.t
    end

  module OO = Tissue.Constructor
  module Command = OO.Command
  module Subject = Subject.Make (Event)
  module OBSERVER = Subject.OBSERVER

  type event = Event.t
  type 'a subscription = 'a Subject.subscription
  type 'a observer     = 'a Subject.observer
             
  type t =
    { subj : Subj.t;
        oo : OO.t
    }

  let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
    let subscription, subj = Subject.subscribe (module Obs) obs_init o.subj in
    subscription, { o with subj }

  let unsubscribe subscription o =
    let obs, subj = Subject.unsubscribe subscription o.subj in
    obs, { o with subj }

  let empty =
  { subj = Subj.empty
      oo = OO.empty;
  }

  let perform command o =
    let oo' = o.oo |> OO.perform command 
    and i   =  oo' |> OO.product
                   |> Tissue.cursor in
    let event = 
      Command.(               Event.( 
        match command with
        | Move side       -> None
        | Add_cytoplasm x -> Some (Cytoplasm_was_added (x, i))
        | Add_nucleus   x -> Some (Nucleus_was_added (x, i))
        | Set_cursor      -> Some (Cursor_was_set i)
        | Set_clot        -> Some (Clot_was_set i) 
      )) in
    let subj =
      match event with
      | Some x -> o.subj |> Subject.send x
      | None   -> o.subj in
    { subj;
      oo = oo'
    }

  let product o =
    OO.product o.oo
    
  end

module Destructor = struct
  module Event = struct
    type t =
      | Cytoplasm_was_removed of Pigment.t * Coord.t
      | Nucleus_was_removed of Nucleus.t * Coord.t
      | Cursor_was_removed of Coord.t
      | Clot_was_removed of Coord.t
    end
        
  module OO = Tissue.Destructor
  module Subject = Subject.Make (Event)
  module OBSERVER = Subject.OBSERVER

  type event = Event.t
  type 'a subscription = 'a Subject.subscription
  type 'a observer     = 'a Subject.observer

  type cell =
    { cytoplasm : Pigment.t option;
        nucleus : Nucleus.t option;
      is_cursor : bool;
        is_clot : bool
    }
                       
  type t =
    {  subj : Subject.t;
      coord : Coord.t;
        acc : cell;
         oo : OO.t;
    }

  let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
    let subscription, subj = Subject.subscribe (module Obs) obs_init o.subj in
    subscription, { o with subj }

  let unsubscribe subscription o =
    let obs, subj = Subject.unsubscribe subscription o.subj in
    obs, { o with subj }

  let empty_cell =
     { cytoplasm = None;
         nucleus = None;
       is_cursor = false;
         is_clot = false
     }
    
  let make tissue =
    {  subj = Subject.empty; 
      coord = Coord.zero;
        acc = empty_cell;
         oo = OO.make tissue
    }

  let destroy_next o =
    let i = o.coord in
    let produce o =
      let send_if condition event o =
        if condition then
          let event = Lazy.force event in
          let subj  = Subject.send event o.subj in
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
      
    let command, oo' = o.oo |> OO.destroy_next  in
    let o'  = { o with oo = oo' } in
    let o'' = let open Constructor.Command in
              match command with
              | None                   -> produce o'      
              | Some (Add_cytoplasm c) ->
                  let acc = { o'.acc with cytoplasm = Some c }
                         in { o' with acc }
              | Some (Add_nucleus n)   ->
                  let acc = { o'.acc with nucleus = Some n }
                         in { o' with acc }
              | Some (Set_cursor)      ->
                  let acc = { o'.acc with is_cursor = true }
                         in { o' with acc }
              | Some (Set_clot)        ->
                  let acc = { o'.acc with is_clot = true }
                         in { o' with acc }

              | Some (Move side)       ->
                            { (produce o') with
                              coord = Coord.move side i
                            } in
    command,
    o''
    
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

  module OO = Tissue.Cursor
  module Command = OO.Command
  module Subject = Subject.Make (Event)
  module OBSERVER = Subj.OBSERVER
  
  type event = Event.t
  type 'a subscription = 'a Subject.subscription
  type 'a observer     = 'a Subject.observer
               
  type t =
    { subj : Subject.t;
        oo : OO.t;
    }

  let subscribe (type obs_t) ((module Obs) : obs_t observer) obs_init o =
    let subscription, subj = Subject.subscribe (module Obs) obs_init o.subj in
    subscription, { o with subj }
                  
  let unsubscribe subscription o =
    let obs, subj = Subject.unsubscribe subscription o.subj in
    obs, { o with subj } 
 
  let make tissue =
    { subj = Subject.empty;
        oo = OO.make tissue
    }
  
  let tissue           o = o.oo |> OO.tissue  
  let is_out_of_tissue o = o.oo |> OO.is_out_of_tissue
  let is_clotted       o = o.oo |> OO.is_clotted

  exception Clotted       = OO.Clotted
  exception Out_of_tissue = OO.Out_of_tissue 

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
    
    let o', event =
      let tissue = tissue o in
      let i = Tissue.cursor tissue in
      
      match command with
      | Command.Turn hand ->
         let before  = cell i tissue  
         and oo'     = OO.perform command o.oo in
         let tissue' = OO.tissue oo' in
         let after   = cell i tissue' in
         
         { o with oo = oo'
         }, Turned { direction = hand; 
                        change = { before; after }
                    }
             
      | Command.Move nature ->
         let direction                     = (Tissue.nucleus i tissue).gaze in
         let ((source, _) as before)       = cells i direction tissue
         and oo'                           = OO.perform command o.oo in
         let tissue'                       = OO.tissue oo' in
         let ((source', target') as after) = cells i direction tissue' in
         let event_data = { direction;
                               change = { before; after };
                               result = `Success
                          } in
       
         { o with oo = oo'
         }, ( match nature with
              | Nature.Mind ->
                  Moved_mind { event_data with
                    result = if target'.cursor_in then
                               `Success else
                               `Fail
                  }
                    
               | Nature.Body ->
                   Moved_body { event_data with
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
         let direction                     = (Tissue.nucleus i tissue).gaze in
         let before                        = cells i direction tissue o
         and oo'                           = OO.perform command o.oo in
         let tissue'                       = OO.tissue oo' in
         let ((source', target') as after) = cells i direction tissue' in
         
         { o with oo = oo'
         }, Replicated { 
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
         
    { o' with 
      subj = Subject.send event o.subj 
    }
    
  end
