open Data.Shared
open Shared.Fail

include Shared.Dots
   
let succ =
  function | OOOOOO -> O
           | OOOOO -> OOOOOO
           | OOOO -> OOOOO
           | OOO -> OOOO
           | OO -> OOO
           | O -> OO

let pred =
  function | OOOOOO -> OOOOO
           | OOOOO -> OOOO
           | OOOO -> OOO
           | OOO -> OO
           | OO -> O
           | O -> OOOOOO
                
let of_char =
  function | '6' -> OOOOOO
           | '5' -> OOOOO
           | '4' -> OOOO
           | '3' -> OOO
           | '2' -> OO
           | '1' -> O
           |  _  -> raise (Inlegal_case "Core.Dots.of_char")   

let of_string str =
  of_char str.[0]
                  
let all = [ OOOOOO;
            OOOOO;
            OOOO;
            OOO;
            OO;
            O
	  ]
