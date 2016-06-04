module Dots = DotsOfDice 
module CrumbMap = Map.Make (Dots)
module PlaceMap = Map.Make (ComparableInt)

module Event = struct
    type t = | Create of Dots.t * int
             | Move   of Dots.t * int * int 
             | Split  of Dots.t * Dots.t * Dots.t * int
	     | Marge  of Dots.t * Dots.t * Dots.t * int

    let create crumb place = 
      lazy(Create (crumb, place))

    let move crumb place place' =
      lazy(Move (crumb, place, place'))

    let split crumb result result' place =
      lazy(Split (crumb, result, result', place))

    let marge crumb crumb' result place =
      lazy(Marge (crumb, crumb', result, place))
end


type t = { crumbs : int CrumbMap.t;
	   places : Dots.t PlaceMap.t;
	     next : (Event.t -> unit) option 
         }

let start =
  { places = PlaceMap.singleton 0 Dots.O;
    crumbs = CrumbMap.singleton Dots.O 0;
      next = None;
  }

let next event x =
  let () = match x.next with
           | Some f -> f (Lazy.force event)
           | None   -> ()
  in
  x

let starto ~observer:next = 
  let () = next (Event.Create (Dots.O, 0)) in 
  { start with next = Some next }

let last x = CrumbMap.max_binding x.crumbs 
let last_place x = snd (last x)  
let last_crumb x = fst (last x)

let count x =
  CrumbMap.cardinal x.crumbs
  
let length x = 
  (last_place x) + 1

let remove c p x = 
  { x with crumbs = x.crumbs |> CrumbMap.remove c;
           places = x.places |> PlaceMap.remove p;
  }

let add c p x = 
  { x with crumbs = x.crumbs |> CrumbMap.add c p;
           places = x.places |> PlaceMap.add p c;
  }

let increment x =
  let c, p = last x in
  x |> next (Event.move c p (p + 1))
    |> remove c p
    |> add c (p + 1)

let decrement x =
   let c , p  = last x in
   let c', p' = (Dots.decrement c), (p - 1) in
   x |> remove c p
     |> next (Event.move c p p')
     |> if PlaceMap.mem p' x.places then 
	  next (Event.split c c' c' p') else 
	  add c p'

let split x =
  let c , p  = last x in 
  let c', p' = (Dots.increment c), (p + 1) in
  x |> next (Event.split c c c' p)
    |> next (Event.move c' p p')
    |> add c' p'
