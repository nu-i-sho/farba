open Utils

module Ordered = struct
  type t = | OOOOOO
           | OOOOO
           | OOOO
           | OOO
           | OO
           | O

  let compare a b =
    match a, b with
      
    | OOOOOO, (OOOOO|OOOO|OOO|OO|O)
    | OOOOO, (OOOO|OOO|OO|O)
    | OOOO, (OOO|OO|O)
    | OOO, (OO|O)
    | OO, (O)        ->  1

    | (OOOOO|OOOO|OOO|OO|O), OOOOOO
    | (OOOO|OOO|OO|O), OOOOO
    | (OOO|OO|O), OOOO
    | (OO|O), OOO
    | (O), OO         -> -1
    | _               ->  0                                

  end

module Map    = MapExt.Make    (Ordered)
module MapOpt = MapExt.MakeOpt (Ordered)

include Ordered
              
let count = 6
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

let all =
  [ OOOOOO;
    OOOOO;
    OOOO;
    OOO;
    OO;
    O
  ]
