open Data.Shared
include Shared.Dots
   
let succ =
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
