type t = White | Blue | Gray
                      
let recessive = function
  | White -> White
  | Blue  -> Gray
  | Gray  -> Blue
