include Shared.Index

let move side (x, y) = 
  Side.( match (x mod 2), side with

	 | 0, Up        -> (x    , y - 1)
         | 0, LeftUp    -> (x - 1, y    )
         | 0, RightUp   -> (x + 1, y    )
         | 0, Down      -> (x    , y + 1) 
         | 0, LeftDown  -> (x - 1, y + 1)
         | 0, RightDown -> (x + 1, y + 1)  

         | 1, Up        -> (x    , y - 1)  
         | 1, LeftUp    -> (x - 1, y - 1)
         | 1, RightUp   -> (x + 1, y - 1)
         | 1, Down      -> (x    , y + 1)
         | 1, LeftDown  -> (x - 1, y    )
         | 1, RightDown -> (x + 1, y    ))

let compare (x_1, y_1) (x_2, y_2) = 
  let by_x = compare x_1 x_2 in
  if by_x = 0 then 
    compare y_1 y_2 else
    by_x
