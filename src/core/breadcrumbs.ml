module CrumbMap = Map.Make (DotsOfDice)
module Int32Map   = Map.Make (Int32)

type t { crumbs = int CrumbMap.t;
	 places = DotsOfDice.t Int32Map.t;
       }

let start = 
  { places = Int32Map.singletot 0 DotsOfDice.O;
    crumbs = CrumbMap.singletot DotsOfDice.O 0;
  }

let last x = CrumbMap.max_binding x.crumbs 
let last_place x = snd (last x)  
let last_crumb x = fst (last x)

let count x =
  CrumbMap.cardinal x.crumbs
  
let length x = 
  (last_place x) + 1

let increment x =
  let crumb, place = last x.crumbs in
  let place' = place + 1 in
  { crumbs = x.crumbs |> CrumbMap.remove crumb
                      |> CrumbMap.add crumb place';
    places = x.places |> Int32Map.remove place
		      |> Int32Map.add place' crumb;
  }

let decrement x =
   let crumb, place = last x.crumbs in
   let y = { crumbs = x.crumbs |> CrumbMap.remove crumb;
             places = x.places |> Int32Map.remove place;
	   }
   in
   
   let place' = place - 1 in
   if x.places |> Int32.mem place' then y else
     { crumbs = y.crumbs |> CrumbMap.add crumb place';
       places = y.places |> Int32Map.add place' crumb;
     }

let multiply x =
  let crumb , place  = last x.crumbs in
  let crumb', place' = 
    (DotsOfDice.increment crumb), (place + 1)
  in

  { crumbs = y.crumbs |> CrumbMap.add crumb' place';
    places = y.places |> Int32Map.add place' crumb';
  }
