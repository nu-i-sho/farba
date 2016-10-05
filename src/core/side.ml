open Data.Shared
open Shared.Fail
type t = side

let of_char = 
  function | 'a' | 'A' -> Up
           | 'b' | 'B' -> RightUp
           | 'c' | 'C' -> RightDown
           | 'd' | 'D' -> Down
           | 'e' | 'E' -> LeftDown
           | 'f' | 'F' -> LeftUp
           |  _        -> raise (Inlegal_case "Core.Side.of_char")
  
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
