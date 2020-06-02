type t = int * int

let compare (x1, y1) (x2, y2) =
  match  compare y1 y2 with
  | 0 -> compare x1 x2
  | x -> x
  
let move side (x, y) =
  let dx, dy =
    match x mod 2, side with
        
    | 0, Side.Up        ->  0, -1  
    | 0, Side.LeftUp    -> -1, -1
    | 0, Side.RightUp   -> +1, -1
    | 0, Side.Down      ->  0, +1
    | 0, Side.LeftDown  -> -1,  0
    | 0, Side.RightDown -> +1,  0
                         
    | 1, Side.Up        ->  0, -1
    | 1, Side.LeftUp    -> -1,  0
    | 1, Side.RightUp   -> +1,  0
    | 1, Side.Down      ->  0, +1 
    | 1, Side.LeftDown  -> -1, +1
    | 1, Side.RightDown -> +1, +1
                           
    | _        -> assert false in
    
  x + dx,
  y + dy
