open Common
open Utils

module Id = Args.Die.Id
module Die = struct
    type t =
      { param : Dots.t;
           id : Id.t
      }

    let param o = o.param
    let make id param =
      { param;
        id
      }

    let is_parent args o =
      (Args.Die.id args) = o.id
  end
           
module Dice = struct
    type t = Dots.t Id.Map.t IntMap.t
           
    let dies i o =
      let make_die (id, param) = Die.make id param in
      ( match IntMap.maybe_item i o with
        | Some dies -> Id.Map.bindings dies
        | None      -> []
      ) |> List.map make_die

    let die i id o =
      o |> IntMap.item i
        |> Id.Map.item id
        |> Die.make id 
      
    let maybe_die i id o =
      match IntMap.maybe_item i o with
      | None      -> None 
      | Some dies -> match Id.Map.maybe_item id dies with
                     | Some param -> Some (Die.make id param)
                     | None       -> None
      
    let add i id param o =
      IntMap.set i (( match IntMap.maybe_item i o with
                      | Some dies -> dies
                      | None      -> Id.Map.empty
                    ) |> Id.Map.set id param)
                 o

    let remove i id o =
      match IntMap.maybe_item i o with
      | None      -> o 
      | Some dies -> let dies = Id.Map.remove id dies in
                     IntMap.set i dies o 
  end
