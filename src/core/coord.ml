module Map = Utils.IntPoint.Map   

type t = int * int
           
let move side (x, y) =
  let dx, dy =     
    if x mod 2 = 0
    then match side with | Up        ->  0, -1  
                         | LeftUp    -> -1, -1
                         | RightUp   -> +1, -1
                         | Down      ->  0, +1
                         | LeftDown  -> -1,  0
                         | RightDown -> +1,  0
    else match side with | Up        ->  0, -1
                         | LeftUp    -> -1,  0
                         | RightUp   -> +1,  0
                         | Down      ->  0, +1 
                         | LeftDown  -> -1, +1
                         | RightDown -> +1, +1 in
    x + dx, 
    y + dy
                       