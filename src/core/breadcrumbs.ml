module CrumbMap = Map.Make (DotsOfDice)
module PlaceMap = Map.Make (ComparableInt)

type t = { crumbs : int CrumbMap.t;
	   places : DotsOfDice.t PlaceMap.t 
         }

let start =
  { places = PlaceMap.singleton 0 DotsOfDice.O;
    crumbs = CrumbMap.singleton DotsOfDice.O 0
  }

let last_pair o = CrumbMap.max_binding o.crumbs 
let last o = fst (last_pair o)
let last_place o = snd (last_pair o)  

let count o =
  CrumbMap.cardinal o.crumbs
  
let length o = 
  (last_place o) + 1

let is_empty o =
  CrumbMap.is_empty o.crumbs

let remove c p o = 
  { crumbs = o.crumbs |> CrumbMap.remove c;
    places = o.places |> PlaceMap.remove p
  }

let add c p o = 
  { crumbs = o.crumbs |> CrumbMap.add c p;
    places = o.places |> PlaceMap.add p c
  }

let increment o =
  let c, p = last_pair o in
  o |> remove c p
    |> add c (p + 1)

let decrement o =
  let c, p  = last_pair o in
  let p' = p - 1 in
  let o = remove c p o in
  if p' > 0 && PlaceMap.mem p' o.places then  
    add c p' o else
    o

let split o =
  let c , p  = last_pair o in 
  let c', p' = (DotsOfDice.increment c), (p + 1) in
  add c' p' o
