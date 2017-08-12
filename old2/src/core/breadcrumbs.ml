type t = (DotsOfDice.t * int) list

let start        = [Data.DotsOfDice.O, 0]
let last_pair    = List.hd 
let last o       = fst (last_pair o)
let last_place o = snd (last_pair o)  
let count        = List.length
let length     o = (last_place o) + 1
let is_empty     = (=) []

let is_splited =
  function | (_, x) :: (_, y) :: _ when x = y 
	       -> true
           | _ -> false

let increment ((a, x) :: t) = (a, x + 1) :: t

let decrement = 
  function | (_, x) :: (b, y) :: t when x = y 
	                 -> (b, y) :: t
           | [_, 0]      -> []
           | (a, x) :: t -> (a, x - 1) :: t

let split ((a, x) :: t) = 
  (DotsOfDice.increment a, x) :: (a, x) :: t
