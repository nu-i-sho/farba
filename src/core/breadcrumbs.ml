module CrumbMap = Map.Make (DotsOfDice)
module IntMap = Map.Make (ComparableInt)

type t = { crumbs : int CrumbMap.t;
	   places : DotsOfDice.t IntMap.t;
         }

let start = 
  { places = IntMap.singleton 0 DotsOfDice.O;
    crumbs = CrumbMap.singleton DotsOfDice.O 0;
  }

let last x = CrumbMap.max_binding x.crumbs 
let last_place x = snd (last x)  
let last_crumb x = fst (last x)

let count x =
  CrumbMap.cardinal x.crumbs
  
let length x = 
  (last_place x) + 1

let increment x =
  let crumb, place = last x in
  let place' = place + 1 in
  { crumbs = x.crumbs |> CrumbMap.remove crumb
                      |> CrumbMap.add crumb place';
    places = x.places |> IntMap.remove place
		      |> IntMap.add place' crumb;
  }

let decrement x =
   let crumb, place = last x in
   let y = { crumbs = x.crumbs |> CrumbMap.remove crumb;
             places = x.places |> IntMap.remove place;
	   }
   in
   
   let place' = place - 1 in
   if x.places |> IntMap.mem place' then y else
     { crumbs = y.crumbs |> CrumbMap.add crumb place';
       places = y.places |> IntMap.add place' crumb;
     }

let multiply x =
  let crumb , place  = last x in
  let crumb', place' = 
    (DotsOfDice.increment crumb), (place + 1)
  in

  { crumbs = x.crumbs |> CrumbMap.add crumb' place';
    places = x.places |> IntMap.add place' crumb';
  }
