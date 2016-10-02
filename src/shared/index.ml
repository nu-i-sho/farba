open Data.Shared
type t = int * int

let move side (x, y) = 
  if x mod 2 = 0
  then match side with | Up        -> (x    , y - 1)  
                       | LeftUp    -> (x - 1, y - 1)
                       | RightUp   -> (x + 1, y - 1)
                       | Down      -> (x    , y + 1)
                       | LeftDown  -> (x - 1, y    )
                       | RightDown -> (x + 1, y    )
  else match side with | Up        -> (x    , y - 1)
                       | LeftUp    -> (x - 1, y    )
                       | RightUp   -> (x + 1, y    )
                       | Down      -> (x    , y + 1) 
                       | LeftDown  -> (x - 1, y + 1)
                       | RightDown -> (x + 1, y + 1)  
