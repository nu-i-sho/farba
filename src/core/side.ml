type t   = | Up
           | LeftUp
           | RightUp
           | Down
           | LeftDown
           | RightDown
let rev  = 
  function | Up         -> Down
           | LeftUp     -> RightDown
           | RightUp    -> LeftDown
           | Down       -> Up
           | LeftDown   -> RightUp
           | RightDown  -> LeftUp
let succ =
  function | Up         -> RightUp
           | RightUp    -> RightDown
	   | RightDown  -> Down
	   | Down       -> LeftDown
	   | LeftDown   -> LeftUp
	   | LeftUp     -> Up                        
let pred = 
  function | Up         -> LeftUp
	   | LeftUp     -> LeftDown
	   | LeftDown   -> Down
	   | Down       -> RightDown
	   | RightDown  -> RightUp
	   | RightUp    -> Up
let turn =
  function | Hand.Left  -> pred
           | Hand.Right -> succ

let compare a b =
  let to_int x = 
    let rec to_int x acc =
      if x = Up then acc else
        to_int (succ x) (Int.succ acc) in
    to_int x 0 in
  (to_int a) -
  (to_int b)

let all =
  [ Up;
    RightUp;
    RightDown;
    Down;
    LeftDown;
    LeftUp
  ]
