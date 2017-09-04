type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

exception Overflow
         
let min = O
let max = OOOOOO
let all = [ OOOOOO;
            OOOOO;
            OOOO;
            OOO;
            OO;
            O
	  ]
        
let to_index =
  function | OOOOOO -> 5
           | OOOOO -> 4
           | OOOO -> 3
           | OOO -> 2
           | OO -> 1
           | O -> 0

let of_index =
  function | 0 -> O
           | 1 -> OO
           | 2 -> OOO
           | 3 -> OOOO
           | 4 -> OOOOO
           | 5 -> OOOOOO
           | _ -> raise (Invalid_argument "Dots.of_index")
                
let count =
  (to_index max) + 1

let compare x y =
  compare (to_index x) (to_index y)

let neighbor move o =
  try o |> to_index
        |> move
        |> of_index
  with (Invalid_argument _) -> raise Overflow
         
let cycle_succ o =
  of_index ((succ (to_index o)) mod count) 

let succ = neighbor succ
let pred = neighbor pred
         
let cycle_pred =
  function | O -> OOOOOO
           | o -> pred o

module Map = Utils.MapExt.Make (struct type t' = t
                                       type t = t'
                                       let compare = compare
                                  end)
