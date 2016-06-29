type t = int * int

let move side (x, y) = 
  Data.Side.( match (x mod 2) <> 0, side with
		
	      | false, Up        -> (x    , y - 1)
              | false, LeftUp    -> (x - 1, y    )
              | false, RightUp   -> (x + 1, y    )
              | false, Down      -> (x    , y + 1) 
              | false, LeftDown  -> (x - 1, y + 1)
              | false, RightDown -> (x + 1, y + 1)  
				  
              | true,  Up        -> (x    , y - 1)  
              | true,  LeftUp    -> (x - 1, y - 1)
              | true,  RightUp   -> (x + 1, y - 1)
              | true,  Down      -> (x    , y + 1)
              | true,  LeftDown  -> (x - 1, y    )
              | true,  RightDown -> (x + 1, y    ))

let compare (x_1, y_1) (x_2, y_2) = 
  let by_x = compare x_1 x_2 in
  if by_x = 0 then 
    compare y_1 y_2 else
    by_x
