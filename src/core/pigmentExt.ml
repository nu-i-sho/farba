open Data
type t = Pigment.t
open Pigment

let opposite = 
   Data.Pigment.opposite
  
let of_char = 
  function | '0' -> White
           | '1' -> Blue
           | '2' -> Gray
           |  _  -> failwith Fail.invalid_symbol 

let to_int = 
  function | White -> 0
           | Blue  -> 1
           | Gray  -> 2

let compare a b = 
  compare (to_int a) (to_int b)
