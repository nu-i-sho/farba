type t = Data.DotsOfDice.t
open Data.DotsOfDice

let increment =
  function | OOOOOO -> O
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OOOO
           | OO -> OOO
           | O -> OO
        
let to_int = 
  function | OOOOOO -> 6
           | OOOOO -> 5
	   | OOOO -> 4
	   | OOO -> 3
	   | OO -> 2
	   | O -> 1

let to_string =
  function | OOOOOO -> "OOOOOO"
           | OOOOO -> "OOOOO"
           | OOOO -> "OOOO"
           | OOO -> "OOO"
           | OO -> "OO"
           | O -> "O"

let all = [ OOOOOO;
            OOOOO;
            OOOO;
            OOO;
            OO;
            O
	  ] 

                
module Map = Map.Make (
                 struct
                     type t = Data.DotsOfDice.t
                     let compare x y = 
                       compare (to_int x) (to_int y)
                   end)
