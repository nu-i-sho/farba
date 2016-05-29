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
