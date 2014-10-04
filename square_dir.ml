type t = | Up
         | Down 
         | Left
	 | Right
	 
let left = function
  | Up    -> Left
  | Left  -> Down
  | Down  -> Right
  | Right -> Up

let right = function
  | Up    -> Right
  | Right -> Down
  | Down  -> Left
  | Left  -> Up

let turn = 
  let open Turn in 
  function
  | Left  -> left
  | Right -> right

let mirror =
  | Up    -> Down
  | Down  -> Up
  | Right -> Left
  | Left  -> Righ
