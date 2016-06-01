type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

let increment =   
  function | OOOOOO -> O
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OOOO
           | OO -> OOO
           | O -> OO

let decrement = 
  function | OOOOOO -> OOOOO
           | OOOOO -> OOOO
           | OOOO -> OOO
           | OOO -> OO
           | OO -> O
           | O -> OOOOOO

let opposite =
  function | OOOOOO -> O
           | OOOOO -> OO
           | OOOO -> OOO
           | OOO -> OOOO
           | OO -> OOOOO
           | O -> OOOOOO

let left =
  function | OOOOOO -> OOO
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OO
           | OO -> O
           | O -> OOOO

let right =
  function | OOOOOO -> OOOOO
           | OOOOO -> OOOO
           | OOOO -> O
           | OOO -> OOOOOO
           | OO -> OOO
           | O -> OO

let of_int =
  function | 6 -> OOOOOO
           | 5 -> OOOOO
	   | 4 -> OOOO
	   | 3 -> OOO
	   | 2 -> OO
	   | 1 -> O

let to_int = 
  function | OOOOOO -> 6
           | OOOOO -> 5
	   | OOOO -> 4
	   | OOO -> 3
	   | OO -> 2
	   | O -> 1

let min a b = 
  of_int (min (to_int a) (to_int b))

let max a b =
  of_int (max (to_int a) (to_int b))
