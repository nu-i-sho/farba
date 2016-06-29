type t = Data.Pigment.t
open Data.Pigment

let opposite = 
  function | None -> None
           | Blue -> Gray
           | Gray -> Blue

let of_char = 
  function | '0' -> None
           | '1' -> Blue
	   | '2' -> Gray
	   |  _  -> failwith "invalid symbol" 

let to_int = 
  function | None -> 0
           | Blue -> 1
           | Gray -> 2

let compare a b = 
  compare (to_int a) (to_int b)
