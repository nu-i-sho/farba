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

let turn = 
  function | Hand.Left  -> left_of 
           | Hand.Right -> right_of

let index_of =
  function | RightUp   -> 0
           | Up        -> 1
           | LeftUp    -> 2
           | LeftDown  -> 3
           | Down      -> 4
           | RightDown -> 5
