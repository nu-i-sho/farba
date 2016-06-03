type t = | Blue
         | Gray
	 | Red

let opposite = 
  function | Blue -> Gray
           | Gray -> Blue
	   | Red  -> Red

let to_char = 
  function | Blue -> '1'
           | Gray -> '0'
	   | Red  -> '2'

let of_char = 
  function | '1' -> Blue
           | '0' -> Gray
	   | '2' -> Red
