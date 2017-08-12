open Data.Shared

module Trace = struct

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

type t = { trace : Trace.t;
             max : int option
         }

let origin =
  { trace = (0, O), [];
      max = None
  }
                    
let limit max o =
  { o with max = Some max
  }

let index o =
  o.trace |> Trace.head
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
  let (i, x), tail = o.trace in
  { o with trace = ((i + length), x), tail
  }

let step =
  jump 1

let back o =
  let trace = 
    match o.trace with
    | (i, _), ((j, _) as e) :: tail
         when i = (succ j) -> e, tail
    | (i, x), tail         -> ((pred i), x), tail
  in
  { o with trace
  }

let succ o =
  let ((i, x) as head), tail = o.trace in
  let trace = ((succ i), (Dots.succ x)),
              (head :: tail) in
  { o with trace
  }
  
let pred o =
  let trace =
    match o.trace with
    | _, (e :: tail) -> e, tail
    | _, []          -> o.trace
  in
  { o with trace
  }

let trace o =
  o.trace
