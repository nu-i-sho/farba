module Ordered = struct
    type t = | OOOOOO
             | OOOOO
             | OOOO
             | OOO
             | OO
             | O


    let to_int =
      function | OOOOOO -> 5
               | OOOOO -> 4
               | OOOO -> 3
               | OOO -> 2
               | OO -> 1
               | O -> 0

    let compare x y =
      compare (to_int x)
              (to_int y)
  end

include Ordered

module Map    = Utils.MapExt.Make    (Ordered)
module MapOpt = Utils.MapExt.MakeOpt (Ordered)
      
let of_int =
  function | 0 -> O
           | 1 -> OO
           | 2 -> OOO
           | 3 -> OOOO
           | 4 -> OOOOO
           | 5 -> OOOOOO
           | _ -> raise (Invalid_argument "Dots.of_index")

let min = O
let max = OOOOOO
let count =
  max |> to_int
      |> succ

let succ o =
  of_int ((succ (to_int o)) mod count) 
     
let pred =
  function | O -> OOOOOO
           | o -> o |> to_int
                    |> pred
                    |> of_int
let all =
  [ OOOOOO;
    OOOOO;
    OOOO;
    OOO;
    OO;
    O
  ]
         
