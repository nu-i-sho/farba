type t = | Up
         | LeftUp
         | RightUp
         | Down
         | LeftDown
         | RightDown

let opposite = 
  function | Up        -> Down
           | LeftUp    -> RightDown
           | RightUp   -> LeftDown
           | Down      -> Up
           | LeftDown  -> RightUp
           | RightDown -> LeftUp

let left_of =
  function | Up        -> LeftUp
           | LeftUp    -> LeftDown
           | LeftDown  -> Down
           | Down      -> RightDown
           | RightDown -> RightUp
           | RightUp   -> Up 

let right_of =
  function | Up        -> RightUp
           | RightUp   -> RightDown
           | RightDown -> Down
           | Down      -> LeftDown
           | LeftDown  -> LeftUp
           | LeftUp    -> Up

let turn ~to':handSide = 
  match handSide with
  | HandSide.Left  -> left_of 
  | HandSide.Right -> right_of

