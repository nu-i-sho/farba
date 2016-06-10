type t = | Blue
         | Gray

let of_char = 
  function | '1' -> Blue
           | '0' -> Gray

let to_char = 
  function | Blue -> '1'
           | Gray -> '0'

