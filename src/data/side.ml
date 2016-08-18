type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

let turn = 
  function | Hand.Left  -> 
	      ( function | Up        -> LeftUp
	                 | LeftUp    -> LeftDown
			 | LeftDown  -> Down
			 | Down      -> RightDown
			 | RightDown -> RightUp
			 | RightUp   -> Up 
	      )
           | Hand.Right -> 
	      ( function | Up        -> RightUp
                         | RightUp   -> RightDown
			 | RightDown -> Down
			 | Down      -> LeftDown
			 | LeftDown  -> LeftUp
			 | LeftUp    -> Up
	      )

let opposite = 
  function | Up        -> Down
           | LeftUp    -> RightDown
           | RightUp   -> LeftDown
           | Down      -> Up
           | LeftDown  -> RightUp
           | RightDown -> LeftUp
