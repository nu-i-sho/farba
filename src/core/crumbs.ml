open Data.Shared
open Shared.Fail

type crumb = int * Crumb.t
type t = crumb list * crumb
 
let origin = [], (0, (Single O))

let item i =
  function | _, (j, x) when j = i
                    -> x
           | oth, _ -> List.assoc i oth

let maybe_item i =
  function | _, (j, x) when j = i
                    -> Some x
           | oth, _ -> if List.mem_assoc i oth then
                         Some (List.assoc i oth) else
                         None
let top =
  function | [], top | (top :: _), _ -> top

let succ =
  function | [], (i, ((Single _) as x))
             -> [], ((succ i), x)

           | ((i, ((Single _) as x)) :: oth), fst
             -> (((succ i), x) :: oth), fst        

           | [], (i, Double (a, b))
             -> [(succ i), (Single b)], (i, (Single a))
              
           | ((i, Double (a, b)) :: oth), fst
             -> (((succ i), (Single b)) :: (i, (Single a)) :: oth),
                fst

let pred =
  function | [i, (Single a)], (j, (Single b))
                when j = pred i
             -> [], (j, (Double (a, b)))

           | ((i, (Single a)) :: (j, (Single b)) :: oth), fst
                when j = pred i
             -> ((j, (Double (a, b))) :: oth), fst

           | [], (i, ((Single _) as x))
             -> [], ((pred i), x)

           | ((i, ((Single _) as x)) :: oth), fst
             -> (((pred i), x) :: oth), fst

           | [], (i, (Double (a, _)))
             -> [], (i, (Single a))

           | ((i, (Double (a, _))) :: oth), fst
             -> ((i, (Single a)) :: oth), fst

let split_top =
  function | [], (i, (Single a))
             -> [], (i, (Single (DotsOfDice.succ a)))

           | ((i, (Single a)) :: oth), fst
             -> ((i, (Single (DotsOfDice.succ a))) :: oth), fst

           | [], (i, (Double _))
           | ((i, (Double _)) :: _), _
             -> raise (Inlegal_case "Core.Crumbs.split_top")

let exists from count =
  let last = from + count in
  function | _, (i, _) when i = from -> true
           | _, (i, _) when i > from -> i < last
           | oth, _               ->
              let rec exists =
                function | (i, _) :: _ when i = from -> true
                         | (i, _) :: _ when i > from -> i < last
                         | _ :: oth                  -> exists oth
                         | []                        -> false in
              exists oth 
