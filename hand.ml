type t = 
  | Left 
  | Right

let compare a b = 
  match a, b with
  | Right, Left  ->  1
  | Left , Right -> -1
  | ____________ ->  0

let opposite = function
  | Left  -> Right
  | Right -> Left
