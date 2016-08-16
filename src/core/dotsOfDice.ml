type t = Data.DotsOfDice.t
open Data.DotsOfDice

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

let index_of =
  function | OOOOOO -> 5
           | OOOOO -> 4
           | OOOO -> 3
           | OOO -> 2
           | OO -> 1
           | O -> 0

let all = [ OOOOOO;
            OOOOO;
            OOOO;
            OOO;
            OO;
            O
	  ]
