type t = Data.Side.t

open Data
open Side

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
  function | Hand.Left  -> left 
           | Hand.Right -> right
