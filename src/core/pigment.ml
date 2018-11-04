type t = | White
         | Blue
         | Gray

let opposite =
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue
           | o     -> o
           
let of_char =
  function | 'g' -> Gray
           | 'b' -> Blue
           | 'w' -> White
           | ___ -> raise (Invalid_arg "Pigment.of_char")
