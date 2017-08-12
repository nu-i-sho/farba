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
