type t = Blue | Gray

let opposite = 
  function | Blue -> Gray
           | Gray -> Blue

let to_char = 
  function | Blue -> '1'
           | Gray -> '0'

let of_char = 
  function | '1' -> Blue
           | '0' -> Gray

 
           

