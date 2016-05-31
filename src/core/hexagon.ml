type t = { storage : (DNA.t option) array array;
             index : int * int;
         }

let value_of hexagon =
  let storage = hexagon.storage in
  let (x, y)  = hexagon.index 
  in
  
  if x < 0 
  || y < 0 
  || x >= (Array.length storage)
  || y >= (Array.length storage.(0)) 
  
  then None 
  else storage.(x).(y)

let neighbor_of hexagon ~from:side = 
  let open HexagonSide in
  let (x, y) = hexagon.index 
  in
  
  { hexagon with index = match side with
                         | Up        -> (x    , y - 1)
                         | LeftUp    -> (x - 1, y - 1)
                         | RightUp   -> (x + 1, y - 1)
                         | Down      -> (x    , y + 1)
                         | LeftDown  -> (x - 1, y    )
                         | RightDown -> (x + 1, y    )
  }
