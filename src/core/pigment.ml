type t = | White
         | Blue
         | Gray
         | None

let opposite =
  function | Blue -> Gray
           | Gray -> Blue
           | o    -> o
           
let of_char =
  function | 'g' -> Gray
           | 'b' -> Blue
           | 'w' -> White
           | ___ -> None
