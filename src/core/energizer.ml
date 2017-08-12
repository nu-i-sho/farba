open Utils.Primitives
open Data.Shared
open Shared.Fail
   
module Crumbs = struct

    type e = int * (dots Doubleable.t)
    type t = e * (e list)

    let head =
      fst

    let as_list o =
      (head o) :: (snd o)
      
    let mayby_item i o = 
      let rec item = 
        function | ((j, e) :: _ when j = i
                             -> i, (Some e)
                 | _ :: tail -> item tail
                 | []        -> i, None
      in
      o |> as_list
        |> item)
      
    let rec exists start count o =
      let last = start + count in
      let rec exists = 
        function | (i, _) :: _ when i = start -> true
                 | (i, _) :: _ when i > start -> i < last
                 | _ :: tail                  -> exists tail
                 | []                         -> false
      in
      o |> as_list
        |> exists
  end

open Doubleable

type t = { crumbs : Crumbs.t;
              max : int option
         }

let origin =
  { crumbs = (0, (Single O)), [];
       max = None
  }
                    
let limit max o =
  { o with max = Some max
  }

let index o =
  o.crumbs |> Crumbs.head
           |> fst 
  
let is_left_out o =
  (index o) < -1

let is_right_out o =
  match o.max with 
  | Some m -> (index o) > m
  | None   -> false

let is_out o =
  (is_left_out o) || (is_right_out o)

let jump length o =
  let crumbs =
    match o.crumbs with

    | (i, (Single x)), tail
      -> ((i + length), (Single x)), tail
       
    | (i, (Double (x, y))), tail
      -> ((i + length), (Single x)), ((i, (Single x)) :: tail)
  in
  { o with crumbs
  }

let step =
  jump 1

let back o =
  let crumbs = 
    match o.crumbs with

    | (i, (Double (x, y))), tail
      -> (i, (Single x)), tail

    | (i, (Single x)), ((j, (Single y)) :: tail)
         when i = (pred j)
      -> (j, (Double (x, y))), tail

    | (i, (Single x)), tail
      -> ((pred i), (Single x)), tail
  in
  { o with crumbs
  }    

let succ o =
  match o.crumbs with

  | (i, (Single x)), tail
    -> (i, (Double ((Dots.succ x), x))), tail
     
  | (_, (Double _)), _
    -> raise (Inlegal_case "Core.Energizer.succ")
     
let pred o =
  let crumbs =
    match o.crumbs with
    | (i, (Double (_, x)), tail
                     -> (i, (Single x)), tail 
    | _, (e :: tail) -> e, tail
    | _, []          -> o.crumbs
  in
  { o with crumbs
  }

let crumbs o =
  o.crumbs
