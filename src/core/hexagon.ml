type t = {   set : Set.t;
           index : int * int;
         }

let make set = 
  { set; 
    index = (0, 0)
  }

let value_of hexagon =
  let set = hexagon.set in
  let (x, y) = hexagon.index 
  in
  
  if x < 0 
  || y < 0 
  || x >= (Array.length set)
  || y >= (Array.length set.(0)) 
  
  then None 
  else set.(x).(y)

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
