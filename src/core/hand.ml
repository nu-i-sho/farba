type t = | Left
         | Right

let opposite =
  function | Left  -> Right
           | Right -> Left
