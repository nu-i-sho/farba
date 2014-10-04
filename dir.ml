type t = | Up
	 | Rightup
	 | Rightdown
	 | Down
	 | Leftdown
	 | Leftup
	 
let left = function
  | Up        -> Leftup
  | Leftup    -> Leftdown
  | Leftdown  -> Down
  | Down      -> Rightdown
  | Rightdown -> Rightup
  | Rightup   -> Up

let right = function
  | Up        -> Rightup
  | Rightup   -> Rightdown
  | Rightdown -> Down
  | Down      -> Leftdown
  | Leftdown  -> Leftup
  | Leftup    -> Up

let turn = 
  let open Turn in 
  function
  | Left  -> left
  | Right -> right

let mirror =
  | Up        -> Down
  | Down      -> Up
  | Rightup   -> Leftdown
  | Leftdown  -> Rightup
  | Rightdown -> Leftup
  | Leftup    -> Rightdown
