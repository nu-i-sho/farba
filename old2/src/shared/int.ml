type t = int

let compare = compare
let round o =
  let fractional, integral = modf o in
  (int_of_float integral) 
  + (if fractional > 0.5 then 
       1 else 
       0)
