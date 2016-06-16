type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

let all = [ OOOOOO;
            OOOOO;
            OOOO;
            OOO;
            OO;
            O
	  ] 

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

let compare x y = 
  compare (to_int x) (to_int y)

let min x y = 
  of_int (min (to_int x) (to_int y))

let max x y =
  of_int (max (to_int x) (to_int y))

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
