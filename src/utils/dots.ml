type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

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

let succ o =
  of_index (((to_index o) + 1) mod count) 
  
let pred =
  function | O -> OOOOOO
           | o -> of_index ((to_index o) - 1) 

module Map = Map.Make (struct type t' = t
                              type t = t'
                              let compare = compare
                       end)
