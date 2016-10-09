open Data.Shared
type t = dots

let count = 6
let index =
  function | OOOOOO -> 5
           | OOOOO -> 4
           | OOOO -> 3
           | OOO -> 2
           | OO -> 1
           | O -> 0

let compare x y =
  compare (index x) (index y)
