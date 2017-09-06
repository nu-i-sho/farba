open Common
open Utils

module Die = struct
    module Id = struct 
        type t = int
        module Map = IntMap
      end
              
    type t =
      { args : command Dots.Map.t;
          id : Id.t
      }

    let empty id =
      { args = Dots.Map.empty;
          id
      }
      
    let id o = o.id
    let arg param o =
      match Dots.Map.maybe_item param o.args with
      | Some arg -> arg
      | None     -> Nope

    let to_list o =
      let arg i = arg i o in 
      List.map arg Dots.all

    let set_arg i command o =
      { o with args = Dots.Map.set i command o.args
      }

    module IdMap = IntMap
  end
             
module Dice = struct
    type t =
      { next_id : Die.Id.t;
        storage : Die.t list Die.Id.Map.t
      }

    let origin =
      { next_id = 0;
        storage = Die.Id.Map.empty;
      }

    let dies i o =
      match Die.Id.Map.maybe_item i o.storage with
      | Some dies -> dies
      | None      -> []
      
    let add_die i o =
      let dies = (Die.empty o.next_id) :: (dies i o) in
      { storage = o.storage |> Die.Id.Map.set i dies;
        next_id = o.next_id |> succ
      }
  end
