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
  | (O), OO        -> -1

  | OOOOOO, OOOOOO
  | OOOOO, OOOOO
  | OOOO, OOOO
  | OOO, OOO
  | OO, OO
  | O, O           ->  0                                
            
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
  let rec gen x =
    x :: ( if x <> max then
             gen (succ x) else
             []
         ) in
  gen min

let char_binding =
  let bind i x =
    (i |> Int.succ
       |> (+) (Char.code '0')
       |> Char.chr
    ), x in
  List.mapi bind all
         
let load src =
  match src () with
  | Seq.Nil -> assert false
  | Seq.Cons (c, next) -> 
     List.assoc c char_binding,
     next
  
let unload o =
  let is_o (_, x) = x = o in
  char_binding |> List.find is_o
               |> fst
               |> Seq.return
