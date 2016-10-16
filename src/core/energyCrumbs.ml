open Data.Shared
open Shared.Fail

type e = int * dots
type t = e list * e
 
let origin = [], (0, O)

let maybe_item i (oth, ((_, c) as fst)) =
  
  let is_actual (j, _) = j = i in
  match (List.filter is_actual oth),
        (is_actual fst) with

  | ((_, a) :: (_, b) :: _), _
                  -> Some (Double (a, b))
  | [_, a], true  -> Some (Double (a, c))
  | [_, a], false -> Some (Single a)
  | []    , true  -> Some (Single c)
  | []    , false -> None
                
let item i o =
  match maybe_item i o with
  | Some item -> item
  | None      -> raise (Inlegal_case "Core.EnergyCrumbs.item")

let top =
  function | ((i, a) :: (j, b) :: _), _
                            when i = j -> i, (Double (a, b))
           | [i, a], (j, b) when i = j -> i, (Double (a, b))
           | ((i, a) :: _), _
           | [], (i, a)                -> i, (Single a)

let exists from count =
  let last = from + count in
  function | _, (i, _) when i = from -> true
           | _, (i, _) when i > from -> i < last
           | oth, _                  ->
              let rec exists =
                function | (i, _) :: _ when i = from -> true
                         | (i, _) :: _ when i > from -> i < last
                         | _ :: oth                  -> exists oth
                         | []                        -> false in
              exists oth
                                        
module Top = struct                                      
    let succ =
      function | [], (i, a)
                 -> [], ((succ i), a)
                  
               | ((i, a) :: oth), fst
                 -> (((succ i), a) :: oth), fst

    let pred =
      function | ((i, _) :: ((j, _) as x) :: oth), fst when i = j
                 -> (x :: oth), fst
                  
               | [i, _], ((j, _) as fst) when i = j
                 -> [], fst

               | ((i, a) :: oth), fst
                 -> (((pred i), a) :: oth), fst

               | [], (i, a)
                 -> [], ((pred i), a)

    let split =
      function | ((i, a) :: oth), fst
                 -> ((i, (Dots.succ a)) :: oth), fst

               | [], (i, a)
                 -> [], (i, (Dots.succ a))
  end
