type t =
  | Up
  | LeftUp
  | LeftDown
  | Down
  | RightDown
  | RightUp

let opposite   = function
  | Up        -> Down
  | LeftUp    -> RightDown
  | LeftDown  -> RightUp
  | Down      -> Up
  | RightDown -> LeftUp
  | RightUp   -> LeftDown

let turn_left  = function
  | Up        -> LeftUp
  | LeftUp    -> LeftDown
  | LeftDown  -> Down
  | Down      -> RightDown
  | RightDown -> RightUp
  | RightUp   -> Up

let turn_right = function
  | Up        -> RightUp
  | RightUp   -> RightDown
  | RightDown -> Down
  | Down      -> LeftDown
  | LeftDown  -> LeftUp
  | LeftUp    -> Up

let turn = function
  | Hand.Left  -> turn_left
  | Hand.Right -> turn_right
