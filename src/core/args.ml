open Common
open Utils
open Std

module Die = struct
    type t = { param : Dots.t;
                 arg : command
             }
  end
   
module Dies = struct
    module Stage = struct
        type t = | Stay
                 | Find
                 | Cover
                 | Wait
                 | Uncover
                 | Return

        let succ = function | Stay    -> Find
                            | Find    -> Cover
                            | Cover   -> Wait
                            | Wait    -> Uncover
                            | Uncover -> Return
                            | Return  -> Stay        
        let pred = function | Stay    -> Find
                            | Find    -> Cover
                            | Cover   -> Wait
                            | Wait    -> Uncover
                            | Uncover -> Return
                            | Return  -> Stay
      end
   
    type t =
      {    args : command Dots.Map.t;
        section : int;
          owner : Energy.Die.t option;
          stage : Stage.t
      }
      
    let empty i =
      {    args = Dots.Map.empty;
        section = i;
          owner = None;
          stage = Stage.Stay
      }
      
    let make i args =
      { (empty i) with args
      }

    let section o = o.section
    let owner o = o.owner
    let stage o = o.stage
      
    let is_empty o =
      Dots.Map.is_empty o.args 
      
    let set_die param arg o =
      { o with
        args = Dots.Map.set param arg o.args
      }
      
    let remove_die param o =
      { o with
        args = Dots.Map.remove param o.args
      }

    let merge x o =
      let f _ a b = match a, b with 
                    | Some cmd, _
                    | _, Some cmd -> Some cmd
                    | None, None  -> None in
      { x with
        args = Dots.Map.merge f x.args o.args
      }
                 
    let die_opt param o =
      match Dots.Map.find_opt param o.args with
      | Some arg -> Some (Die.{ arg; param })
      | None     -> None
      
    let die param o =
      Die.{ arg = Dots.Map.find param o.args;
            param
          }

    let change_stage f owner o =
      let stage = f o.stage in
      let owner =
        match stage with
        | Stage.Stay -> None
        | _          -> Some owner in
      { o with
        stage;
        owner
      }
       
    let next_stage = change_stage Stage.succ 
    let prev_stage = change_stage Stage.pred
  end

module Dice = struct
    module IMap = IntMap
    module DMap = Energy.Die.MapOpt 
  
    type t = Dies.t DMap.t IMap.t

    let make source_args =
      source_args |> IMap.mapi Dies.make
                  |> IMap.map (DMap.singleton None) 
      
    let empty = IMap.empty

    let dies i owner o =
      o |> IMap.find i
        |> DMap.find owner

    let dies_opt i owner o =
      match IMap.find_opt i o with
      | Some dies -> DMap.find_opt owner dies
      | None      -> None
           
    let rec change_dies i owner change o =
      let section =          
        match IMap.find_opt i o with
        | Some section -> section
        | None         -> DMap.empty in

      let dies =
        ( match DMap.find_opt owner section with
          | Some dies -> dies 
          | None      -> Dies.empty i
        ) |> change in

      let j = Dies.section dies 
      and owner' = Dies.owner dies in
      let moved = i <> j in
      let section =
        section |> DMap.remove owner
                |> ( if (not moved) && not (Dies.is_empty dies) then
                       DMap.add owner' dies else
                       as_is
                   ) in
        
      o |> ( if DMap.is_empty section then
                IMap.remove i else
                IMap.set i section
           )
        |> ( if moved then            
                change_dies j owner' (Dies.merge dies) else
                as_is
           )
  end
