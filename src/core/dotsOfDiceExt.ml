open Data
type t = DotsOfDice.t
open DotsOfDice

let index_of = Data.DotsOfDice.index_of  
let compare  = Data.DotsOfDice.compare
   
let increment =
  function | OOOOOO -> O
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OOOO
           | OO -> OOO
           | O -> OO

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
