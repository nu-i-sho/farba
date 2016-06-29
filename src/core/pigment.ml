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
