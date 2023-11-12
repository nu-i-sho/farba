module Coord = struct
  type t = int * int

  let zero = 1, 1

  let compare (x1, y1) (x2, y2) =
    match  compare x1 x2 with
    | 0 -> compare y1 y2
    | n -> n
          
  let move side (x, y) =
    match side with    
    | Side.Up        -> x    , y - 2
    | Side.Down      -> x    , y + 2
    | Side.RightDown -> x + 2, y + 1
    | Side.LeftUp    -> x - 2, y - 1
    | Side.RightUp   -> x + 2, y - 1
    | Side.LeftDown  -> x - 2, y + 1
  end

include Map.Make(Coord)
