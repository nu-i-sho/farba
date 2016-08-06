type t = Data.DotsOfDice.t
open Data.DotsOfDice

let increment =
  function | OOOOOO -> O
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OOOO
           | OO -> OOO
           | O -> OO
