open Data
   
type t = Crumb.t list

open Doubleable
open Crumb
       
let start =
  [{ value = Single DotsOfDice.O;
     index = 0
  }]

let top = List.hd
        
let move o =
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

let back o =
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
    -> { value = Single (DotsOfDiceExt.increment a);
         index = i
       } :: o

  | { value = Double _; _ }
    -> failwith Fail.cannot_split
