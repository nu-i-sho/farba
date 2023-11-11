module Coord = struct
  type t = int * int

  let zero = 0, 0

  let compare (i1, j1) (i2, j2) =
    match  compare i1 i2 with
    | 0 -> compare j1 j2
    | x -> x
          
  let move side (i, j) =
    let di, dj =
      match (j mod 2 = 0), side with
        
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
    
    i + di,
    j + dj

  let to_2D eR iR (i, j) = 
    iR * (i * 2 + 1),
    eR * ((j + (i mod 2)) * 2 + abs ((i mod 2) - 1))
    
  end

include Map.Make(Coord)
