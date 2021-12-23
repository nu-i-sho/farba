type t = White | Blue | Gray
                      
let opposite = function
  | White -> White
  | Blue  -> Gray
  | Gray  -> Blue
