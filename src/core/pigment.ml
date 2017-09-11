open Common

type t = pigment

let opposite =
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue

let of_char =
  function | 'g' -> Gray
           | 'b' -> Blue
           | 'w' -> White
           | ___ -> raise (Invalid_argument "Pigment.of_char")
