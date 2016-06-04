module Dots = DotsOfDice 
module CrumbMap = Map.Make (Dots)
module PlaceMap = Map.Make (ComparableInt)

module Event = struct
    type t = | New   (Dots.t * int)
             | Move  (Dots.t * int * int) 
             | Split (Dots.t * Dots.t * Dots.t * int)
	     | Marge (Dots.t * Dots.t * Dots.t * int)
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
  let () = match x.on_event with
           | Some on -> on !event
           | None    -> ()
  in
  x

let starto observer = 
  { start with next = Some observer } 
  |> next Event.(New (Dots.O, 0))

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
  x |> next Event.(Move (c, p, p + 1))
    |> remove c p
    |> add c (p + 1)

let decrement x =
   let rec (c, p), c', p' = 
     (last x), (Dots.increment c), (p - 1)
   in

   x |> remove c p
     |> next Event.(Move (c, p, p'))
     |> if PlaceMap.mem p' x.places then 
	  next Event.(Split (c, c', c', p')) else 
	  add c p'

let split x =
  let rec (c, p), c', p' = 
    (last x), (Dots.increment c), (p + 1) 
  in

  x |> next Event.(Split (c, c, c', p))
    |> next Event.(Split (c', p, p'))
    |> add c' p'
