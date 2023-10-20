type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O                          
            
let min = O
let max = OOOOOO

let succ = function
  | O -> OO
  | OO -> OOO
  | OOO -> OOOO
  | OOOO -> OOOOO
  | OOOOO -> OOOOOO
  | OOOOOO -> O
          
let pred = function
  | OOOOOO -> OOOOO
  | OOOOO -> OOOO
  | OOOO -> OOO
  | OOO -> OO
  | OO -> O
  | O -> OOOOOO

