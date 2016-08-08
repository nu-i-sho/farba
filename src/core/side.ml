type t = Data.Side.t
open Data.Side

let opposite = 
  function | Up        -> Down
           | LeftUp    -> RightDown
           | RightUp   -> LeftDown
           | Down      -> Up
           | LeftDown  -> RightUp
           | RightDown -> LeftUp

let turn = 
  function | Data.Hand.Left  -> 
	      ( function | Up        -> LeftUp
	                 | LeftUp    -> LeftDown
			 | LeftDown  -> Down
			 | Down      -> RightDown
			 | RightDown -> RightUp
			 | RightUp   -> Up 
	      )
           | Data.Hand.Right -> 
	      ( function | Up        -> RightUp
                         | RightUp   -> RightDown
			 | RightDown -> Down
			 | Down      -> LeftDown
			 | LeftDown  -> LeftUp
			 | LeftUp    -> Up
	      )
