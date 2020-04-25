type t = | White
         | Blue
         | Gray

let reverse =
  function | White -> White
           | Blue  -> Gray
           | Gray  -> Blue
