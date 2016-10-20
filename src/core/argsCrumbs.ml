open Utils
open Primitives
open Data.Shared
   
type e = | Active of args
         | Static of args
      
type active = int * args

type t = {    all : args IntMap.t;
           active : active option
         }

let active o = o.active 

let item i o =
  match o.active with 
  | Some (_, x) -> Active x
  | None        -> Static (IntMap.item i o.all) 

let maybe_item i o =
  match o.active with 
  | Some (_, x) -> Some (Active x)
  | None        ->
     ( match IntMap.maybe_item i o.all with
       | Some x -> Some (Static x)
       | None   -> None
     )

let activate i o =
  let activate o =
    match IntMap.maybe_item i o.all with
    |  None    -> { o with active = None }
    | (Some x) -> {    all = IntMap.remove i o.all;
                    active = Some (i, x)
                  } in
    
  match o.active with
  | Some (j, _) when j = i -> o
  | None                   -> o |> activate
  | Some (j, x)            ->
     let o = activate o in
     { o with all = IntMap.add j x o.all
     }
                 
let of_string x =
  {    all = IntMap.of_string Args.of_string x;
    active = None
  }

let update_active f o =
  { o with active = ( match o.active with
                      | Some x -> Some (f x)
                      | None   -> None
                    )
  }
              
module Active = struct
    let succ (i, x) = (succ i), x
    let pred (i, x) = (pred i), x
    let jump i (_, x) = i, x
  end
