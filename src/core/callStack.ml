type t = Data.CallStackPoint.t list
open Data.CallStackPoint.Value
open Data.CallStackPoint
       
let start =
  [{ value = Single Data.DotsOfDice.O;
     index = 0
  }]

let top = List.hd
  
let increment o =
  match List.hd o with

  | { value = Single a; index = i }
    -> { value = Single a;
         index = i + 1
       } :: (List.tl o)
    
  | { value = Double (a, b); index = i }
    -> { value = Single b;
         index = i + 1
       } :: { value = Single a;
              index = i
            } :: (List.tl o)

let decrement o =
  match List.hd o with
    
  | { value = Single a; index = i }
    -> { value = Single a;
         index = i - 1
       } :: (List.tl o)
     
  | { value = Double (a, _); index = i }
    -> { value = Single a;
         index = i
       } :: (List.tl o)

let split o =
  match List.hd o with

  | { value = Single a; index = i }
    -> { value = Single (DotsOfDice.increment a);
         index = i
       } :: o

  | { value = Double _; _ }
    -> failwith "cannot split splitted point"
