type t = | Up
	 | Rightup
	 | Rightdown
	 | Down
	 | Leftdown
	 | Leftup
	 
module Turn = struct
  let t = | Left
          | Right 
end

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

let x dir = (+)
  (match dir with
   | Up        -> 0
   | Down      -> 0
   | Rightup   -> 1
   | Rightdown -> 1
   | Leftdown  -> -1
   | Leftup    -> -1)

let y dir y =
  let q = if y % 2 = 0 
          then 1 
          else 0 in
  match dir with
  | Up        -> y + q 
  | Rightup   -> y + q 
  | Leftup    -> y + q
  | Rightdown -> y + q - 1 
  | Down      -> y + q - 1
  | Leftdown  -> y + q - 1

let of_string = function
  | "Up"        -> Up
  | "Rightup"   -> Rightup
  | "Rightdown" -> Rightdown
  | "Down"      -> Down
  | "Leftdown"  -> Leftdown
  | "Leftup"    -> Leftup
