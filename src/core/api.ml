module SubjectOf = struct
  module Tissue = struct
    module Constructor = Subject.Make (OTissue.Constructor.Event)
    module Cursor      = Subject.Make (OTissue.Cursor.Event)
    module Destructor  = Subject.Make (OTissue.Destructor.Event)
    end
  end

type tissue_cursor_subscription =
  SubjectOf.Tissue.Cursor.t OTissue.Cursor.subscription

module Settings = struct  
  type t =
    { tissue_constructor_subject : SubjectOf.Tissue.Constructor.t;
           tissue_cursor_subject : SubjectOf.Tissue.Cursor.t;
       tissue_destructor_subject : SubjectOf.Tissue.Destructor.t;
      tissue_cursor_subscription : tissue_cursor_subscription option
    }
    
  let empty =
    { tissue_constructor_subject = SubjectOf.Tissue.Constructor.empty;
           tissue_cursor_subject = SubjectOf.Tissue.Cursor.empty;
       tissue_destructor_subject = SubjectOf.Tissue.Destructor.empty;
      tissue_cursor_subscription = None
    }
  end

module Runtime = struct
  type t =
    { processor : Processor.t;
       level_id : int;
        session : string;
       settings : Settings.t
    }
  end

type settings = [ `Settings of Settings.t ]
type runtime  = [ `Runtime  of Runtime.t ]
type any      = [ settings | runtime ]

open Settings
open Runtime
              
let empty = `Settings empty
   
let settings = function
  | `Settings x -> x
  | `Runtime  x -> x.settings

let with_settings x = function
  | `Settings _ -> `Settings x
  | `Runtime  o -> `Runtime { o with settings = x }

module File = struct

  let destruct =
    let rec destruct acc d =
      let command, d = OTissue.Destructor.next d in
      match command with
      | Some x -> destruct (x :: acc) d
      | None   -> acc, d in
    destruct []
  
  module Close = struct
    type result = settings

    (* Api.File.Close.perform *)
    let perform (`Runtime r) =
      let s = r.settings in
      
      let tissue_cursor_subject, cursor =
        let cursor = Processor.cursor r.processor in
        match s.tissue_cursor_subscription with
        | Some x -> OTissue.Cursor.unsubscribe x cursor
        | None   -> s.tissue_cursor_subject, cursor in
      
      let destructor =
        cursor |> OTissue.Cursor.tissue
               |> OTissue.Destructor.make in
        
      let subscription, destructor =
        OTissue.Destructor.subscribe
          (module SubjectOf.Tissue.Destructor)
           s.tissue_destructor_subject
           destructor in

      let _, destructor = destruct destructor in
      let tissue_destructor_subject, _ = 
        OTissue.Destructor.unsubscribe subscription destructor in

      `Settings {
          s with
          tissue_destructor_subject;
          tissue_cursor_subject;
          tissue_cursor_subscription = None
        }
      
    end
  
  let rec load tissue_build tape = function
    | (`Runtime _) as runtime  ->
       load tissue_build tape (Close.perform runtime)

    | (`Settings s)            ->
       
       let subscription, constructor =
         OTissue.Constructor.subscribe
           (module SubjectOf.Tissue.Constructor)
            s.tissue_constructor_subject
            OTissue.Constructor.empty
       
       and perform = Fun.flip OTissue.Constructor.perform in
       let constructor = List.fold_left perform constructor tissue_build in
       let tissue_constructor_subject, constructor =
         OTissue.Constructor.unsubscribe subscription constructor in

       let tissue = OTissue.Constructor.product constructor in
       let cursor = OTissue.Cursor.make tissue in
    
       let cursor_subscription, cursor =
         OTissue.Cursor.subscribe
           (module SubjectOf.Tissue.Cursor)
            s.tissue_cursor_subject
            cursor in

       let tissue_cursor_subscription = Some cursor_subscription
       and processor = Processor.make cursor tape in
       let settings  =
         { s with
           tissue_constructor_subject;
           tissue_cursor_subscription
         } in
    
       `Runtime  {
           processor;
           level_id = -1;
           session = "";
           settings;
         }
          
  module OpenNew = struct
    type error =
      [ `Level_is_missing
      | `Level_is_unavailable
      ]
    and result =
      [ `Error of error
      |  runtime
      ]

    (* Api.File.OpenNew.perform *)
    let perform level o = 
      match Levels.get_opt level Levels.std with
      | None                          -> `Error `Level_is_missing
      | Some (module Level : LEVEL.S) ->
         let tape = Tape.start Source.empty in
         let tissue_build = Level.get_tissue_build () in
         load tissue_build tape o
    end

  module Access = struct
    type error =
      [ `Permission_denied
      ]
    end
                 
  module Restore = struct
    type error =
      [  Access.error
      | `Backup_not_found
      | `Backup_is_corrupted
      ]
    and result =
      [ `Error of error
      |  runtime 
      ]

    (* Api.File.Restore.perform *)
    let perform level name o =
      try let backup = Backup.restore level name in
          load backup.tissue_build backup.tape o
          
      with | Backup.Is_corrupted      _ -> `Error `Backup_is_corrupted
           | Backup.Not_found         _ -> `Error `Backup_not_found
           | Backup.Permission_denied _ -> `Error `Permission_denied
    end

  module Save = struct
    type error =
      [  Access.error
      | `Name_is_empty
      ]
    and result =
      [ `Error of error
      |  runtime
      ]

    (* Api.File.Save.perform *)
    let perform (`Runtime o) =
      try if o.session = "" then
            `Error `Name_is_empty else
            
            let tissue_build =
              o.processor |> Processor.cursor
                          |> OTissue.Cursor.tissue
                          |> OTissue.Destructor.make
                          |> destruct
                          |> fst
                          |> List.rev
            and tape = 
              o.processor |> Processor.tape in

            let () = Backup. { tissue_build;
                       tape
                     } |> Backup.save o.level_id o.session in

            `Runtime o
      with | Backup.Permission_denied _ ->
            `Error `Permission_denied        
    end
              
  (* Api.File.SaveAs.perform *)
  module SaveAs = struct
    type error =
      [  Save.error
      | `Backup_already_exists
      ]
    and result =
      [ `Error of error
      |  runtime
      ]
               
    let perform name (`Runtime o) =
      if Backup.exists o.level_id name then
        `Error `Backup_already_exists  else
        Save.perform (`Runtime { o with session = name })
    end

  (* Api.File.SaveAsForce.perform *)
  module SaveAsForce = struct
    type error = Save.error
    and result =
      [ `Error of error
      |  runtime
      ]
               
    let perform name (`Runtime o) =
        Save.perform (`Runtime { o with session = name })
    end
  end

module EventsOf = struct
  module Tissue = struct
    
    module Constructor =
      ReObservable.Make(SubjectOf.Tissue.Constructor)
        ( struct type t = any
                 
                 let pack tissue_constructor_subject o =
                   with_settings {
                       (settings o) with
                       tissue_constructor_subject
                     } o
               
                 let unpack o =
                   (settings o).tissue_constructor_subject
            
                 end
        )
         
    module Destructor =
      ReObservable.Make(SubjectOf.Tissue.Destructor)
        ( struct type t = any
                 
                 let pack tissue_destructor_subject o =
                   with_settings {
                       (settings o) with
                       tissue_destructor_subject
                     } o
                   
                 let unpack o =
                   (settings o).tissue_destructor_subject
            
                 end
        )
         
    module Cursor =
      ReObservable.Make(SubjectOf.Tissue.Cursor)
        ( struct type t = any
                 
                 let pack tissue_cursor_subject o =
                   with_settings {
                       (settings o) with
                       tissue_cursor_subject
                     } o
                   
                 let unpack o =
                   (settings o).tissue_cursor_subject
            
                 end
        )       
    end
                
  end
