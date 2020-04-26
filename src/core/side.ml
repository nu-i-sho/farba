type t   = | Up
           | LeftUp
           | RightUp
           | Down
           | LeftDown
           | RightDown
let rev  = 
  function | Up        -> Down
           | LeftUp    -> RightDown
           | RightUp   -> LeftDown
           | Down      -> Up
           | LeftDown  -> RightUp
           | RightDown -> LeftUp
let succ =
  function | Up        -> RightUp
           | RightUp   -> RightDown
	   | RightDown -> Down
	   | Down      -> LeftDown
	   | LeftDown  -> LeftUp
	   | LeftUp    -> Up                        
let pred = 
  function | Up        -> LeftUp
	   | LeftUp    -> LeftDown
	   | LeftDown  -> Down
	   | Down      -> RightDown
	   | RightDown -> RightUp
	   | RightUp   -> Up
let turn =
  let open Common in
  function | Left  -> pred
           | Right -> succ
