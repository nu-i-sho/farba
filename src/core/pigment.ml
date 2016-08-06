type t = Data.Pigment.t
open Data.Pigment

let opposite = 
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue

let of_char = 
  function | '0' -> White
           | '1' -> Blue
           | '2' -> Gray
           |  _  -> failwith "invalid symbol" 

let to_int = 
  function | White -> 0
           | Blue  -> 1
           | Gray  -> 2

let compare a b = 
  compare (to_int a) (to_int b)
