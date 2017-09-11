open Common
   
type t = side

let of_char =
  function | '0' -> Up
           | '1' -> LeftUp
           | '2' -> RightUp
           | '3' -> Down
           | '4' -> LeftDown
           | '5' -> RightDown
           | ___ -> raise (Invalid_argument "Side.of_char")
       
let opposite = 
  function | Up        -> Down
           | LeftUp    -> RightDown
           | RightUp   -> LeftDown
           | Down      -> Up
           | LeftDown  -> RightUp
           | RightDown -> LeftUp
let left = 
  function | Up        -> LeftUp
	   | LeftUp    -> LeftDown
	   | LeftDown  -> Down
	   | Down      -> RightDown
	   | RightDown -> RightUp
	   | RightUp   -> Up
let right =
  function | Up        -> RightUp
           | RightUp   -> RightDown
	   | RightDown -> Down
	   | Down      -> LeftDown
	   | LeftDown  -> LeftUp
	   | LeftUp    -> Up                        
let turn = 
  function | Left  -> left 
           | Right -> right
