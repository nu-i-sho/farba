module Coord = struct
  type t = int * int

  let zero = 0, 0

  let compare (x1, y1) (x2, y2) =
    match  compare y1 y2 with
    | 0 -> compare x1 x2
    | n -> n
          
  let move side (x, y) =
    let dx, dy =
      match (y mod 2 = 0), side with
        
      |     _, Side.Up        ->  0, -1
      |     _, Side.Down      ->  0, +1
  
      |  true, Side.LeftUp    -> -1, -1
      |  true, Side.RightUp   -> +1, -1
      |  true, Side.LeftDown  -> -1,  0
      |  true, Side.RightDown -> +1,  0
                           
      | false, Side.LeftUp    -> -1,  0
      | false, Side.RightUp   -> +1,  0
      | false, Side.LeftDown  -> -1, +1
      | false, Side.RightDown -> +1, +1 in
                                        
    x + dx,
    y + dy
           
  end

include Map.Make(Coord)
