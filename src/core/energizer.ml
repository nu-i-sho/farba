open Data.Shared

module Crumbs = struct

    type e = int * dots
    type t = e * (e list)
           
    let head =
      fst

    let rec to_list o =
      (head o) :: (snd o)
      
    let try_get i o =
      let rec try_get = 
        function | ((j, _) as e) :: _ when i = j
                             -> Some e
                 | _ :: tail -> try_get tail
                 | []        -> None
      in
      o |> to_list
        |> try_get 
      
    let rec exists start count o =
      let last = start + count in
      let rec exists = 
        function | (i, _) :: _ when i = start -> true
                 | (i, _) :: _ when i > start -> i < last
                 | _ :: tail                  -> exists tail
                 | []                         -> false
      in
      o |> to_list
        |> exists 
  end

type t = { crumbs : Crumbs.t;
             args : args option;
              max : int option
         }

let origin =
  { crumbs = (0, O), [];
      args = None;
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
  let (i, x), tail = o.crumbs in
  { o with crumbs = ((i + length), x), tail
  }

let step =
  jump 1

let back o =
  let crumbs = 
    match o.crumbs with
    | (i, _), ((j, _) as e) :: tail
         when i = (succ j) -> e, tail
    | (i, x), tail         -> ((pred i), x), tail
  in
  { o with crumbs
  }

let succ o =
  let ((i, x) as head), tail = o.crumbs in
  let crumbs = ((succ i), (Dots.succ x)),
               (head :: tail) in
  { o with crumbs
  }
  
let pred o =
  let crumbs =
    match o.crumbs with
    | _, (e :: tail) -> e, tail
    | _, []          -> o.crumbs
  in
  { o with crumbs
  }

let attach args o =
  { o with args = Some args
  }
  
let attachment o =
  o.args

let detach o =
  { o with args= None;
  }
  
let crumbs o =
  o.crumbs
