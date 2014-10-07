type t = | Up
	 | Rightup
	 | Rightdown
	 | Down
	 | Leftdown
	 | Leftup
	 
let left = 

let right = 

let turn = 
  let open Turn in 
  function
  | Left  -> function
      | Up        -> Leftup
      | Leftup    -> Leftdown
      | Leftdown  -> Down
      | Down      -> Rightdown
      | Rightdown -> Rightup
      | Rightup   -> Up
  | Right -> function
      | Up        -> Rightup
      | Rightup   -> Rightdown
      | Rightdown -> Down
      | Down      -> Leftdown
      | Leftdown  -> Leftup
      | Leftup    -> Up

let mirror =
  | Up        -> Down
  | Down      -> Up
  | Rightup   -> Leftdown
  | Leftdown  -> Rightup
  | Rightdown -> Leftup
  | Leftup    -> Rightdown
