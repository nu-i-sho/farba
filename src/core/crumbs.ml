open Data.Shared
open Shared.Fail
   
type t = (int * Crumb.t) list
 
let origin = [0, (Single O)]
let item   = List.assoc

let maybe_item i o =
  if List.mem_assoc i o then
    Some (List.assoc i o) else
    None
  
let top =
  function | top :: _ -> top
           | []       -> raise Impossible_case
                       
let succ =
  function | (i, ((Single _) as x)) :: tl
                -> ((succ i), x) :: tl              

           | (i, Double (a, b)) :: tl
                -> ((succ i), (Single b)) :: (i, (Single a)) :: tl

           | [] -> raise Impossible_case           

let pred =
  function | (i, (Single a)) :: (j, (Single b)) :: tl
                when j = pred i
                -> (j, (Double (a, b))) :: tl

           | (i, ((Single _) as x)) :: tl
                -> ((pred i), x) :: tl

           | (i, (Double (a, _))) :: tl
             -> (i, (Single a)) :: tl

           | [] -> raise Impossible_case

let split_top =
  function | (i, (Single a)) :: tl
                -> (i, (Single (DotsOfDice.succ a))) :: tl

           | (i, (Double _)) :: tl
                -> raise (Inlegal_case "Core.Crumbs.split_top")
           | [] -> raise  Impossible_case

let rec exists start count =
  function | (i, _) :: tl when i = start -> true
           | (i, _) :: _  when i > start -> i < (start + count)
           | _ :: tl                     -> exists start count tl
           | []                          -> false
