type t = | OOOOOO
         | OOOOO
         | OOOO
         | OOO
         | OO
         | O

let index_of =
  function | OOOOOO -> 5
           | OOOOO -> 4
           | OOOO -> 3
           | OOO -> 2
           | OO -> 1
           | O -> 0

let compare x y =
  compare (index_of x)
          (index_of y)
