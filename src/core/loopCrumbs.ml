open Data.Shared
open Utils

type e = | Active of dots
         | Static of dots

type active = dots * dots

type t = { active : active option;
              all : dots IntMap.t
         }

let of_string x =
  { active = None;
       all = IntMap.of_string Dots.of_string x
  }

let active o =
  match o.active with
  | Some (x, _) -> Some x
  | None        -> None
                 
let item i o =
  match o.active with
  | Some (x, _) -> Active x
  | None        -> Static (IntMap.item i o.all)


let maybe_item i o =
  match o.active with 
  | Some (x, _) -> Some (Active x)
  | None        ->
     ( match IntMap.maybe_item i o.all with
       | Some x -> Some (Static x)
       | None   -> None
     )

let activate i o =
  let active =
    match IntMap.maybe_item i o.all with
    | Some x -> Some (i, i, x)
    | None   -> None in
  
  { o with active
  }
    
let active o =
  ()

let activate i o =
  ()
               
module Active = struct
    let succ = ()
    let pred = ()
    let return = ()
  end
  
module Item = struct
    let iter i o =
      match item i o with

      | Static O
        -> o
         
      | Active (O, origin)
        -> o |> IntMap.put i (Static origin)
         
      | Static origin
        -> o |> IntMap.put i (Active ((Dots.pred origin), origin))

      | Active (current, origin)
        -> o |> IntMap.put i (Active ((Dots.pred current), origin)) 
  end
